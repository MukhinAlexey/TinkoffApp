import Foundation
import CoreLocation

class PointsInteractor {
    weak var output: PointsInteractorOutput!
    var imageDownloaderService: ImageDownloaderService!
    var networkService: NetworkService!
    var locationService: LocationService!

    private var isUserPostionSet = false
    //private var searchRadius: CLLocationDistance!
    private var visitedCoordinates = [CLLocationCoordinate2D]()
    private var lastCoordinate: CLLocationCoordinate2D!

    let reachability = Reachability()!
}

extension PointsInteractor: PointsInteractorInput {

    func authLocationService() {
        locationService.auth()
        locationService.delegate = self
    }

    func getPartnersList() {

        guard reachability.connection == .none else {
            return
        }

        networkService.getPartnersList { partners, error in
            guard
                error == nil,
                let partners = partners else {
                    return
            }

            CoreDataService.shared.save(partners)

            CoreDataService.shared.getPartnersList { partners, error in
                
                /*
                 var partnersPresentation = [PartnerPresentation]()
                 partnersPresentation = PartnerToPresentation()
                 .mapArrays(partners: partners,
                 partnersPresentation: partnersPresentation)

                 DispatchQueue.main.async {
                 self.output.didGet(partnersPresentation)
                 }
                 */
            }
        }
    }

    func mapMove(to coordinate: CLLocationCoordinate2D,
                 topRightCordinate: CLLocationCoordinate2D,
                 bottomLeftCordinate: CLLocationCoordinate2D) {

        if reachability.connection == .none {
            DispatchQueue.main.async {
                self.output.didGoOffline()
            }
        } else {
            DispatchQueue.main.async {
                self.output.didGoOnline()
            }
        }

        CoreDataService.shared
            .getPoints(for: coordinate,
                       topRightCoordinate: topRightCordinate,
                       bottomLeftCoordinate: bottomLeftCordinate)
            { points, error in

                guard
                    error == nil,
                    let points = points else {
                        return
                }

                let pointsPresentationInit =
                    [PointPresentation](repeating: PointPresentation(),
                                        count: points.count)

                let pointsPresentation = PointMapper().mapArray(points, to: pointsPresentationInit)

                DispatchQueue.main.async {
                    self.output.didGet(pointsPresentation)
                }
        }

        if lastCoordinate == nil {
            lastCoordinate = coordinate
        }

        let locationFrom = CLLocation(latitude: lastCoordinate.latitude,
                                      longitude: lastCoordinate.longitude)
        let locationTo = CLLocation(latitude: coordinate.latitude,
                                    longitude: coordinate.longitude)

        let coordinatEdgeLocation = CLLocation(latitude: topRightCordinate.latitude,
                                               longitude: topRightCordinate.longitude)

        let coordinatCenterLocation = CLLocation(latitude: coordinate.latitude,
                                                 longitude: coordinate.longitude)

        let searchRadius = coordinatEdgeLocation.distance(from: coordinatCenterLocation)

        guard locationTo.distance(from: locationFrom) > searchRadius / 2.0 else {
            return
        }

        lastCoordinate = coordinate

        guard reachability.connection != .none else {
            return
        }

        networkService.getPoints(for: coordinate,
                                 with: searchRadius)
        {
            pointsJSON, error in

            guard
                error == nil,
                let pointsJSON = pointsJSON else {
                    return
            }

            CoreDataService.shared.savePoints(pointsJSON) { points, error in
                guard
                    error == nil,
                    let points = points else {
                        return
                }

                let pointsPresentationInit = [PointPresentation](repeating: PointPresentation(),
                                                                 count: points.count)

                let pointsPresentation = PointMapper().mapArray(points, to: pointsPresentationInit)

                DispatchQueue.main.async {
                    self.output.didGet(pointsPresentation)
                }
            }
        }
    }
}

extension PointsInteractor: LocationServiceDelegate {

    func didAuthorize() {
        output.didAuthorizeLocation()
    }

    func didUpdate(_ coordinates: CLLocationCoordinate2D) {
        if !isUserPostionSet {
            DispatchQueue.main.async {
                self.output.didUpdate(coordinates)
            }
        }
        isUserPostionSet = true
    }
}
