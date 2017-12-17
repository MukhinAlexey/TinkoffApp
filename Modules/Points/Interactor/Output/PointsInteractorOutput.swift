import Foundation
import CoreLocation

protocol PointsInteractorOutput: class {

    func didLoad(_ imageData: Data, for point: PointPresentation)

    func didAuthorizeLocation()

    func didUpdate(_ coordinates: CLLocationCoordinate2D)

    func didGet(_ points: [PointPresentation])
    func didGet(_ partners: [PartnerPresentation])

    func didGoOnline()
    func didGoOffline()
}
