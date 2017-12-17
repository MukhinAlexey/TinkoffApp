import Foundation
import CoreLocation

protocol PointsPresenterOutput: class {
    func didLoad(_ image: Data, for point: PointPresentation)
    func didAuthorizeLocation()
    func didUpdate(_ coordinates: CLLocationCoordinate2D)

    func didGet(_ points: [PointPresentation])

    func didGet(error: Error)

    func didGoOnline()
    
    func didGoOffline()
}
