import CoreLocation

protocol BalanceIncreaseViewOutput {
    func viewIsReady()
    func mapMove(to coordinate: CLLocationCoordinate2D,
                 topRightCordinate: CLLocationCoordinate2D,
                 bottomLeftCordinate: CLLocationCoordinate2D)
    func didTap(on point: PointPresentation)
}
