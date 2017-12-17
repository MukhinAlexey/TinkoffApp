import UIKit
import CoreData
import CoreLocation

class CoreDataService {

    static let shared = CoreDataService()

    lazy var masterContext: NSManagedObjectContext = {
        let masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = persistentStoreCoordinator
        masterContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        masterContext.undoManager = nil
        return masterContext
    }()

    lazy var readContext: NSManagedObjectContext = {
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = masterContext
        mainContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        mainContext.undoManager = nil
        return mainContext
    }()

    lazy var saveContext: NSManagedObjectContext = {
        let saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = readContext
        saveContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        saveContext.undoManager = nil
        return saveContext
    }()

    func performSave(in context: NSManagedObjectContext,
                     completionHandler: (() -> Void)?) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                }
                if let parent = context.parent {
                    self.performSave(in: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?()
                }
            } else {
                completionHandler?()
            }
        }
    }

    static let modelName = "TinkoffApp"

    private var persistentStoreURL: URL {
        let storeName = "\(CoreDataService.modelName).sqlite"
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                             in: .userDomainMask).first!
        return documentsDirectoryURL.appendingPathComponent(storeName)
    }

    private let managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: CoreDataService.modelName,
                                             withExtension: "momd") else {
                                                fatalError("Error getting model url")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        return persistentStoreCoordinator
    }()

}

extension CoreDataService {

    func save(_ partners: [[String:AnyObject]]) {
        saveContext.perform {
            for partner in partners {
                _ = Partner(json: partner, insertIntoManagedObjectContext: self.saveContext)
            }
            self.performSave(in: self.saveContext, completionHandler: nil)
        }
    }

    func savePoints(_ points: [[String:AnyObject]],
                    completition: @escaping ([Point]?, Error?) -> Void) {
        var pointsObjects = [Point]()
        saveContext.perform {
            for point in points {
                let pointObject = Point.update(json: point,
                                               insertIntoManagedObjectContext: self.saveContext)
                pointsObjects.append(pointObject)
            }
            completition(pointsObjects, nil)
            self.performSave(in: self.saveContext, completionHandler: nil)
        }
    }

    func getPartnersList(completition: @escaping ([Partner]?, Error?) -> Void) {
        readContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Partner")
            do {
                let results = try self.readContext.fetch(fetchRequest)
                for result in results as! [NSManagedObject] {
                    //print("ID - \(result.value(forKey: "id")!)")
                }
            } catch {
                print(error)
            }
        }
    }

    func getPoints(for coordinate: CLLocationCoordinate2D,
                   topRightCoordinate: CLLocationCoordinate2D,
                   bottomLeftCoordinate: CLLocationCoordinate2D,
                   completition: @escaping ([Point]?, Error?) -> Void) {
        readContext.perform {
                let results = Point.get(coordinate,
                                        topRightCoordinate: topRightCoordinate,
                                        bottomLeftCoordinate: bottomLeftCoordinate,
                                        in: self.readContext)
                completition(results, nil)
        }
    }
}
