import Foundation
import CoreLocation
import UIKit

protocol PointsPresenterOutput: class {
    func didAuthorizeLocation()
    func didUpdate(_ coordinates: CLLocationCoordinate2D)

    func didGet(_ points: [PointPresentation])
    func didGet(_ partners: [PartnerPresentation])

    func didLoad(_ image: UIImage, for point: PointPresentation)

    func didGet(error: Error)

    func didGoOnline()
    
    func didGoOffline()
}
