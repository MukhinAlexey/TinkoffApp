import UIKit
import GoogleMaps

class PointsViewController: UIViewController {

    var output: BalanceIncreaseViewOutput!

    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var statusLabel: LabelView!
    @IBOutlet weak var statusLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var networkStatusLabel: LabelView!
    @IBOutlet weak var networkStatusLabelLeftConstraint: NSLayoutConstraint!

    @IBOutlet weak var zoomInZoomOutViewRightConstraint: NSLayoutConstraint!

    var isInfoViewShown = false

    let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        hideInfoView()
        output.viewIsReady()
    }

    private func showInfoView() {
        infoViewBottomConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3) {
            self.mapView.padding = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: self.infoView.bounds.size.height / 3,
                                                right: 0)
        }
        animateLayout()
    }

    private func hideInfoView() {
        infoViewBottomConstraint.constant = -300.0
        UIView.animate(withDuration: 0.3) {
            self.mapView.padding = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
        }
        animateLayout()
    }

    private func showLegend() {
        statusLabelTopConstraint.constant = 8.0
        zoomInZoomOutViewRightConstraint.constant = 16.0
        animateLayout()
    }

    private func hideLegend() {
        statusLabelTopConstraint.constant = -100.0
        zoomInZoomOutViewRightConstraint.constant = -100.0
        animateLayout()
    }

    private func animateLayout() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func didPressZoomInButton(_ sender: RoundButton) {
        let zoomInCamera = GMSCameraUpdate.zoomIn()
        mapView.animate(with: zoomInCamera)
    }

    @IBAction func didPressZoomOutButton(_ sender: RoundButton) {
        let zoomOutCamera = GMSCameraUpdate.zoomOut()
        mapView.animate(with: zoomOutCamera)
    }

}

extension PointsViewController: PointsPresenterOutput {

    func didAuthorizeLocation() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    func didLoad(_ image: Data,
                 for point: PointPresentation) {

    }

    func didUpdate(_ coordinates: CLLocationCoordinate2D) {
        mapView.animate(to: GMSCameraPosition(target: coordinates,
                                              zoom: AppConstant.initMapZoom,
                                              bearing: 0,
                                              viewingAngle: 0))
    }

    func didGetMarkers(_ coordinates: [CLLocationCoordinate2D]) {
        for coordinate in coordinates {
            let position = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                  longitude: coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.icon = GMSMarker.markerImage(with: .red)
            marker.map = mapView
        }
    }

    func didGet(_ points: [PointPresentation]) {
        print(" ")
        print("============VIEW=============")
        print("points count: \(points.count)")
        mapView.clear()
        for point in points {
            let position = CLLocationCoordinate2D(latitude: point.coordinate.latitude,
                                                  longitude: point.coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.icon = GMSMarker.markerImage(with: .red)
            marker.title = point.partnerName
            marker.map = mapView
        }
        statusLabel.set("Обновлено")
    }

    func didGet(error: Error) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Произошла ошибка",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func didGoOnline() {
        networkStatusLabel.set("Вы онлайн")
        networkStatusLabelLeftConstraint.constant = -100.0
        animateLayout()
    }

    func didGoOffline() {
        networkStatusLabel.set("Вы оффлайн")
        networkStatusLabelLeftConstraint.constant = 8.0
        animateLayout()
    }
}

extension PointsViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView,
                 willMove gesture: Bool) {
        statusLabel.set("Загрузка")
        DispatchQueue.main.async {
            self.hideLegend()
            self.hideInfoView()
        }
    }

    func mapView(_ mapView: GMSMapView,
                 idleAt position: GMSCameraPosition) {

        DispatchQueue.main.async {
            self.showLegend()
        }

        guard mapView.camera.zoom >= 15.0 else {
            mapView.clear()
            statusLabel.set("Далеко")
            return
        }

        let projection = GMSCoordinateBounds(region: mapView.projection.visibleRegion())

        let topRightCorner = projection.northEast
        let bottomLeftCorner = projection.southWest

        output.mapMove(to: position.target,
                       topRightCordinate: topRightCorner,
                       bottomLeftCordinate: bottomLeftCorner)
    }

    func mapView(_ mapView: GMSMapView,
                 didTap marker: GMSMarker) -> Bool {
        if !isInfoViewShown {
            showInfoView()
            isInfoViewShown = true
        } else {
            hideInfoView()
            isInfoViewShown = false
        }
        return true
    }
}
