import UIKit
import CoreLocation

class PointMapper {

    func map(_ point: Point,
             to pointPresentation: PointPresentation) -> PointPresentation {
        let lat = point.lat
        let lon = point.lon
        let mappedPointPresentation =
            PointPresentation(partnerName: point.partnerName!,
                              coordinate:
                CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: lat!),
                                       longitude: CLLocationDegrees(truncating: lon!)))
        return mappedPointPresentation
    }

    func map(_ points: [Point],
                   to pointsPresentation: [PointPresentation]) -> [PointPresentation] {
        guard points.count == pointsPresentation.count else {
            return pointsPresentation
        }

        var mappedPointsPresentation = [PointPresentation]()

        for point in points {
            let index = points.index(of: point)!
            let mappedPointPresentation = map(point, to: pointsPresentation[index])
            mappedPointsPresentation.append(mappedPointPresentation)
        }
        return mappedPointsPresentation
    }
}
