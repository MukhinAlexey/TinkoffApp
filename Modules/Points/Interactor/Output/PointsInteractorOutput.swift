import Foundation
import CoreLocation

protocol PointsInteractorOutput: class {

    func didLoad(_ image: Data, for balanceIncreasePoint: NSObject)

    func didAuthorizeLocation()

    func didUpdate(_ coordinates: CLLocationCoordinate2D)

    func didGet(_ points: [PointPresentation])
    func didGet(_ partners: [PartnerPresentation])

    func didGoOnline()
    func didGoOffline()
}
