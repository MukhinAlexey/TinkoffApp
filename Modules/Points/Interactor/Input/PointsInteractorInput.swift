import Foundation
import CoreLocation

protocol PointsInteractorInput: class {

    func authLocationService()
    func getPartners()

    func mapMove(to coordinate: CLLocationCoordinate2D,
                 topRightCordinate: CLLocationCoordinate2D,
                 bottomLeftCordinate: CLLocationCoordinate2D)

    func tap(on point: PointPresentation)
}
