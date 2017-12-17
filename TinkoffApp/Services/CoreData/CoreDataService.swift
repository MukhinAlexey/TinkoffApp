import UIKit
import CoreData
import CoreLocation

class CoreDataService {

    var coreDataStack: CoreDataStack!

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}

extension CoreDataService {

    func savePartners(_ partners: [[String:AnyObject]],
                      completition: @escaping ([Partner]?, Error?) -> Void) {
        var partnersObject = [Partner]()
        coreDataStack.saveContext.perform {
            for partner in partners {
                let partnerObjectOptional = Partner.update(json: partner,
                                                           intoManagedObjectContext: self.coreDataStack.saveContext)
                guard let partnerObject = partnerObjectOptional else {
                    continue
                }
                partnersObject.append(partnerObject)
            }
            completition(partnersObject, nil)
            self.coreDataStack.performSave(in: self.coreDataStack.saveContext, completionHandler: nil)
        }
    }

    func savePoints(_ points: [[String:AnyObject]],
                    completition: @escaping ([Point]?, Error?) -> Void) {
        var pointsObjects = [Point]()
        coreDataStack.saveContext.perform {
            for point in points {
                let pointObjectOptional = Point.update(json: point,
                                                       insertIntoManagedObjectContext: self.coreDataStack.saveContext)
                guard let pointObject = pointObjectOptional else {
                    continue
                }
                pointsObjects.append(pointObject)
            }
            completition(pointsObjects, nil)
            self.coreDataStack.performSave(in: self.coreDataStack.saveContext, completionHandler: nil)
        }
    }

    func getPartners(completition: @escaping ([Partner]?, Error?) -> Void) {
        coreDataStack.readContext.perform {
            let fetchRequest = NSFetchRequest<Partner>(entityName: "Partner")
            do {
                let results = try self.coreDataStack.readContext.fetch(fetchRequest)
                completition(results, nil)
            } catch {
                completition(nil, error)
            }
        }
    }

    func getPoints(for coordinate: CLLocationCoordinate2D,
                   topRightCoordinate: CLLocationCoordinate2D,
                   bottomLeftCoordinate: CLLocationCoordinate2D,
                   completition: @escaping ([Point]?, Error?) -> Void) {
        coreDataStack.readContext.perform {
            let results = Point.get(coordinate,
                                    topRightCoordinate: topRightCoordinate,
                                    bottomLeftCoordinate: bottomLeftCoordinate,
                                    in: self.coreDataStack.readContext)
            completition(results, nil)
        }
    }
}
