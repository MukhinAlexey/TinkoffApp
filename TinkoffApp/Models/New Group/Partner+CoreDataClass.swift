import Foundation
import CoreData

@objc(Partner)
public class Partner: NSManagedObject {

}

extension Partner {
    convenience init?(json: [String: Any],
                      insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Partner", in: context)!
        self.init(entity: entity, insertInto: context)

        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let picture = json["picture"] as? String else {
                return nil
        }

        self.id = id
        self.name = name
        self.picture = picture
    }
}
