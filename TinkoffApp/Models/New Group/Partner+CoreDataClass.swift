import Foundation
import CoreData

@objc(Partner)
public class Partner: NSManagedObject {

}

extension Partner {

    static let entityName = "Partner"

    static func update(json: [String: Any],
                       intoManagedObjectContext context: NSManagedObjectContext) -> Partner? {

        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let picture = json["picture"] as? String else {
                return nil
        }

        let partner = getPartner(with: id, in: context)

        partner.id = id
        partner.name = name
        partner.picture = picture

        return partner
    }

    static func getPartner(with id: String,
                           in context: NSManagedObjectContext) -> Partner {
        let fetchRequest = NSFetchRequest<Partner>(entityName: "Partner")

        fetchRequest.predicate = NSPredicate(format: "id = %@", id)

        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count != 0 {
                return fetchResults.first!
            }
        } catch {
            return NSEntityDescription.insertNewObject(forEntityName: Partner.entityName,
                                                       into: context) as! Partner
        }
        return NSEntityDescription.insertNewObject(forEntityName: Partner.entityName,
                                                   into: context) as! Partner
    }
}
