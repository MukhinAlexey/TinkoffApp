import Foundation
import CoreData

extension Point {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Point> {
        return NSFetchRequest<Point>(entityName: "Point")
    }

    @NSManaged public var addressInfo: String?
    @NSManaged public var fullAddress: String?
    @NSManaged public var lat: NSDecimalNumber?
    @NSManaged public var lon: NSDecimalNumber?
    @NSManaged public var partnerName: String?
    @NSManaged public var phone: String?
    @NSManaged public var searchDate: NSDate?
    @NSManaged public var workHours: String?
    @NSManaged public var pointToPartner: Partner?
}
