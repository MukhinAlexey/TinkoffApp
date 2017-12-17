import Foundation
import CoreData
import CoreLocation

@objc(Point)
public class Point: NSManagedObject {

}

extension Point {
    static let entityName = "Point"

    static func update(json: [String: Any],
                       insertIntoManagedObjectContext context: NSManagedObjectContext) -> Point? {

        guard
            let partnerName = json["partnerName"] as? String,
            let coordinates = json["location"] as? [String: Any],
            let lat = coordinates["latitude"] as? NSNumber,
            let lon = coordinates["longitude"] as? NSNumber else {
                return nil
        }

        let point = get(byLatitude: NSDecimalNumber(decimal: lat.decimalValue),
                        lontitude: NSDecimalNumber(decimal: lon.decimalValue),
                        in: context)

        point.partnerName = partnerName
        point.lat = NSDecimalNumber(decimal: lat.decimalValue)
        point.lon = NSDecimalNumber(decimal: lon.decimalValue)
        return point
    }

    static func get(byLatitude latitude: NSDecimalNumber,
                    lontitude: NSDecimalNumber,
                    in context: NSManagedObjectContext) -> Point {
        let fetchRequest = NSFetchRequest<Point>(entityName: "Point")
        fetchRequest.predicate = NSPredicate(format: "(lat = %@) AND (lon = %@)", latitude, lontitude)
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count != 0 {
                return fetchResults.first!
            }
        } catch {
            return NSEntityDescription.insertNewObject(forEntityName: Point.entityName, into: context) as! Point
        }
        return NSEntityDescription.insertNewObject(forEntityName: Point.entityName, into: context) as! Point
    }

    static func get(_ coordinate: CLLocationCoordinate2D,
                    topRightCoordinate: CLLocationCoordinate2D,
                    bottomLeftCoordinate: CLLocationCoordinate2D,
                    in context: NSManagedObjectContext) -> [Point]? {
        let fetchRequest = NSFetchRequest<Point>(entityName: "Point")

        fetchRequest.predicate = NSPredicate(format: "(lat > %@) AND (lat < %@) AND (lon < %@) AND (lon > %@)",
                                             NSDecimalNumber(value: bottomLeftCoordinate.latitude),
                                             NSDecimalNumber(value: topRightCoordinate.latitude),
                                             NSDecimalNumber(value: topRightCoordinate.longitude),
                                             NSDecimalNumber(value: bottomLeftCoordinate.longitude))

        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count != 0 {
                return fetchResults
            }
        } catch {
            return nil
        }
        return nil
    }
}
