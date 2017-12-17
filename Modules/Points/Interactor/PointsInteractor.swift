import Foundation
import CoreLocation

class PointsInteractor {
    weak var output: PointsInteractorOutput!
    var imageDownloaderService: ImageDownloaderService!
    var networkService: NetworkService!
    var locationService: LocationService!
    var coreDataService: CoreDataService!

    private var isUserPostionSet = false
    private var lastCoordinate: CLLocationCoordinate2D!

    let reachability = Reachability()!

    var isFirstLaunch = true
}

extension PointsInteractor: PointsInteractorInput {
    func authLocationService() {
        locationService.auth()
        locationService.delegate = self
    }

    func getPartnersList() {

        guard reachability.connection != .none else {
            return
        }

        coreDataService.getPartners(completition: self.returnToView(_:error:))

        networkService.getPartnersList { partners, error in

            guard
                error == nil,
                let partners = partners else {
                    return
            }

            self.coreDataService.savePartners(partners, completition: self.returnToView(_:error:))

        }
    }

    private func returnToView(_ partners: [Partner]?, error: Error?) {
        guard
            error == nil,
            let partners = partners else {
                return
        }
        let partnersPresentationInit = [PartnerPresentation](repeating: PartnerPresentation(),
                                                             count: partners.count)

        let partnersPresentation = PartnerMapper().map(partners, to: partnersPresentationInit)
        DispatchQueue.main.async {
            self.output.didGet(partnersPresentation)
        }
    }

    private func returnToView(_ points: [Point]?, error: Error?) {
        guard
            error == nil,
            let points = points else {
                return
        }
        let pointsPresentationInit = [PointPresentation](repeating: PointPresentation(),
                                                         count: points.count)
        let pointsPresentation = PointMapper().map(points, to: pointsPresentationInit)
        DispatchQueue.main.async {
            self.output.didGet(pointsPresentation)
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

        coreDataService
            .getPoints(for: coordinate,
                       topRightCoordinate: topRightCordinate,
                       bottomLeftCoordinate: bottomLeftCordinate,
                       completition: returnToView(_:error:))

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

        guard
            locationTo.distance(from: locationFrom) > searchRadius / 2.0 || isFirstLaunch else {
                return
        }

        isFirstLaunch = false
        lastCoordinate = coordinate

        guard reachability.connection != .none else {
            return
        }
        
        networkService.getPoints(for: coordinate, with: searchRadius) { pointsJSON, error in

            guard
                error == nil,
                let pointsJSON = pointsJSON else {
                    return
            }

            self.coreDataService.savePoints(pointsJSON, completition: self.returnToView(_:error:))
        }
    }

    func tap(on point: PointPresentation) {
        imageDownloaderService.downloadImage(named: point.picture) { imageData, error in
            guard
                error == nil,
                let imageData = imageData else {
                    return
            }
            DispatchQueue.main.async {
                self.output.didLoad(imageData, for: point)
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
