import Foundation
import CoreData

@objc(Partner)
public class Partner: NSManagedObject {

}

extension Partner {

    static let entityName = "Partner"

    static func updateOrInsertNew(json: [String: Any],
                                  intoManagedObjectContext context: NSManagedObjectContext) -> Partner? {

        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let description = json["description"] as? String,
            let picture = json["picture"] as? String else {
                return nil
        }

        let partnerOptional = getPartner(withId: id, in: context)
        var partner: Partner

        if partnerOptional == nil {
            partner = NSEntityDescription.insertNewObject(forEntityName: Partner.entityName,
                                                          into: context) as! Partner
        } else {
            partner = partnerOptional!
        }

        partner.id = id
        partner.name = name
        partner.picture = picture
        partner.info = description

        return partner
    }

    static func update(withId id: String,
                       lastModified: String,
                       intoManagedObjectContext context: NSManagedObjectContext) -> Partner? {

        let partnerOptional = getPartner(withId: id, in: context)

        guard let partner = partnerOptional else {
            return nil
        }

        partner.pictureLastModified = lastModified
        return partner
    }
    
    static func getPartner(withId id: String,
                           in context: NSManagedObjectContext) -> Partner? {
        let fetchRequest = NSFetchRequest<Partner>(entityName: "Partner")

        fetchRequest.predicate = NSPredicate(format: "id = %@", id)

        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count != 0 {
                return fetchResults.first!
            }
        } catch {
            return nil
        }
        return nil
    }
}
