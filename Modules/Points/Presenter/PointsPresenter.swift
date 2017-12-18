import Foundation
import CoreLocation
import UIKit

// Презентер просто проксирует, получилось так себе
class PointsPresenter {
    weak var view: PointsPresenterOutput!
    var interactor: PointsInteractorInput!

    func viewIsReady() {
        interactor.authLocationService()
        interactor.getPartners()
    }

    func mapMove(to coordinate: CLLocationCoordinate2D,
                 topRightCordinate: CLLocationCoordinate2D,
                 bottomLeftCordinate: CLLocationCoordinate2D) {
        interactor.mapMove(to: coordinate,
                           topRightCordinate: topRightCordinate,
                           bottomLeftCordinate: bottomLeftCordinate)
    }

    func tap(on point: PointPresentation) {
        interactor.tap(on: point)
    }
}

extension PointsPresenter: PointsPresenterInput {
    func didGet(_ points: [PointPresentation]) {
        view.didGet(points)
    }

    func didGet(_ partners: [PartnerPresentation]) {
        view.didGet(partners)
    }

    func didNotGetPartners(with errorMessage: String) {
        view.didNotGetPartners(with: errorMessage)
    }

    func didLoad(_ image: UIImage, for point: PointPresentation) {
        view.didLoad(image, for: point)
    }

    func didAuthorizeLocation() {
        view.didAuthorizeLocation()
    }

    func didFinishUpdating() {
        view.didFinishUpdating()
    }

    func didUpdate(_ coordinates: CLLocationCoordinate2D) {
        view.didUpdate(coordinates)
    }

    func didGoOnline() {
        view.didGoOnline()
    }
    
    func didGoOffline() {
        view.didGoOffline()
    }

    func didGet(_ errorMessage: String) {
        view.didGet(errorMessage)
    }
}
