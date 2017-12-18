import Foundation
import CoreData

extension Partner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Partner> {
        return NSFetchRequest<Partner>(entityName: "Partner")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var picture: String?
    @NSManaged public var pictureLastModified: String?

    @NSManaged public var url: String?
    @NSManaged public var depositionDuration: String?
    @NSManaged public var hasLocations: Bool
    @NSManaged public var isMomentary: Bool
    @NSManaged public var limitations: String?
    @NSManaged public var pointType: String?
    @NSManaged public var partnerToPoint: NSSet?
}

// MARK: Generated accessors for partnerToBalanceIncreasePoint
extension Partner {

    @objc(addPartnerToPointObject:)
    @NSManaged public func addToPartnerToPoint(_ value: Point)

    @objc(removePartnerToPointObject:)
    @NSManaged public func removeFromPartnerToPoint(_ value: Point)

    @objc(addPartnerToPoint:)
    @NSManaged public func addToPartnerToPoint(_ values: NSSet)

    @objc(removePartnerToPoint:)
    @NSManaged public func removeFromPartnerToPoint(_ values: NSSet)
}
