import Foundation
import CoreLocation
import UIKit

protocol PointsInteractorOutput: class {

    func didLoad(_ image: UIImage, for point: PointPresentation)

    func didAuthorizeLocation()

    func didUpdate(_ coordinates: CLLocationCoordinate2D)

    func didGet(_ points: [PointPresentation])
    func didGet(_ partners: [PartnerPresentation])

    func didGoOnline()
    func didGoOffline()
}
