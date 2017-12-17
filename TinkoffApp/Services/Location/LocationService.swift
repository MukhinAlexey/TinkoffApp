import UIKit

protocol LocationService: class {
    func auth()
    func startUpdatingLocation()
    func stopUpdatingLocation()

    weak var delegate: LocationServiceDelegate? { get set }
}
