import Foundation
import CoreLocation

class PointsPresenter {
    weak var view: PointsPresenterOutput!
    var interactor: PointsInteractorInput!

    func viewIsReady() {
        interactor.authLocationService()
        interactor.getPartnersList()
    }

    func mapMove(to coordinate: CLLocationCoordinate2D,
                 topRightCordinate: CLLocationCoordinate2D,
                 bottomLeftCordinate: CLLocationCoordinate2D) {
        interactor.mapMove(to: coordinate,
                           topRightCordinate: topRightCordinate,
                           bottomLeftCordinate: bottomLeftCordinate)
    }
}

extension PointsPresenter: PointsPresenterInput {

    func didGet(_ points: [PointPresentation]) {
        view.didGet(points)
    }

    func didGet(_ partners: [PartnerPresentation]) {

    }

    func didLoad(_ image: Data,
                 for balanceIncreasePoint: NSObject) {

    }

    func didAuthorizeLocation() {
        view.didAuthorizeLocation()
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
}
