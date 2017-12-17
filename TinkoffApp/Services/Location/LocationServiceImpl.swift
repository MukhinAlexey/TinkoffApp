import UIKit
import CoreLocation

protocol LocationServiceDelegate: class {
    func didUpdate(_ coordinates: CLLocationCoordinate2D)
    func didAuthorize()
}

class LocationServiceImpl: NSObject, LocationService {
    let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func auth() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startUpdatingLocation()
            delegate?.didAuthorize()
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let coordinates = location.coordinate
        delegate?.didUpdate(coordinates)
    }
}
