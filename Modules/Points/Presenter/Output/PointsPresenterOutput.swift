import Foundation
import CoreLocation
import UIKit

protocol PointsPresenterOutput: class {
    func didAuthorizeLocation()

    func didFinishUpdating()
    func didUpdate(_ coordinates: CLLocationCoordinate2D)

    func didGet(_ points: [PointPresentation])
    func didLoad(_ image: UIImage, for point: PointPresentation)

    func didGet(_ partners: [PartnerPresentation])
    func didNotGetPartners(with errorMessage: String)

    func didGet(_ errorMessage: String)

    func didGoOnline()
    func didGoOffline()
}
