import UIKit
import GoogleMaps

class PointsViewController: UIViewController {

    var output: BalanceIncreaseViewOutput!

    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var infoView: InfoView!
    @IBOutlet weak var infoViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var statusLabel: LabelView!
    @IBOutlet weak var statusLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var networkStatusLabel: LabelView!
    @IBOutlet weak var networkStatusLabelLeftConstraint: NSLayoutConstraint!

    @IBOutlet weak var zoomInZoomOutViewRightConstraint: NSLayoutConstraint!

    var pointsOnMap = [PointPresentation]()
    var partners = [PartnerPresentation]()

    var showingInfoViewIsInProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        hideInfoView()
        output.viewIsReady()
    }

    private func showInfoView() {
        infoViewBottomConstraint.constant = 0.0
        let mapViewFrame = self.mapView.frame
        animateMapInset(withBottomInset: mapViewFrame.size.height / 3.0)
        animateLayout()
    }

    private func animateMapInset(withBottomInset bottomInset: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.mapView.padding = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: bottomInset,
                                                right: 0)
        }
    }

    private func hideInfoView() {
        infoViewBottomConstraint.constant = -300.0
        infoView.image = nil
        animateMapInset(withBottomInset: 0)
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

    func didLoad(_ image: UIImage, for point: PointPresentation) {
        infoView.set(image)
    }

    func didUpdate(_ coordinates: CLLocationCoordinate2D) {
        mapView.animate(to: GMSCameraPosition(target: coordinates,
                                              zoom: AppConfig.initMapZoom,
                                              bearing: 0,
                                              viewingAngle: 0))
    }

    func didGet(_ points: [PointPresentation]) {
        pointsOnMap.removeAll()
        pointsOnMap = points
        mapView.clear()
        for point in points {
            let position = CLLocationCoordinate2D(latitude: point.coordinate.latitude,
                                                  longitude: point.coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.icon = GMSMarker.markerImage(with: .red)
            marker.title = point.partnerName
            marker.map = mapView
            point.marker = marker
        }
        statusLabel.set("Обновлено")
    }

    func didGet(_ partners: [PartnerPresentation]) {
        self.partners = partners
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
        }
    }

    func mapView(_ mapView: GMSMapView,
                 idleAt position: GMSCameraPosition) {
        showLegend()

        if !showingInfoViewIsInProgress {
            hideInfoView()
        }
        showingInfoViewIsInProgress = false

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
        self.showInfoView()
        showingInfoViewIsInProgress = true
        didUpdate(marker.position)
        let point = pointsOnMap.first(where: {
            $0.marker == marker
        })!
        let partner = partners.first {
            $0.id == point.partnerName
        }!
        point.picture = partner.picture
        infoView.set(partner.name)
        output.tap(on: point)
        return true
    }

    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        //showLegend()
    }
}
