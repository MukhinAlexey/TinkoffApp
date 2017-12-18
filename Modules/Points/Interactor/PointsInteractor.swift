import Foundation
import CoreLocation

class PointsInteractor {
    weak var output: PointsInteractorOutput!
    var imageDownloadService: ImageDownloadService!
    var partnerService: PartnerNetworkService!
    var pointService: PointNetworkService!
    var locationService: LocationService!
    var coreDataService: CoreDataService!

    private var lastVisitedCoordinate: CLLocationCoordinate2D!

    private let reachability = Reachability()!

    private var isUserPostionSet = false
    private var isFirstLaunch = true
}

extension PointsInteractor: PointsInteractorInput {

    func authLocationService() {
        locationService.auth()
        locationService.delegate = self
    }

    func getPartners() {
        coreDataService.getPartners { partners, error in

            // Не сделал нормальную обработку ошибок, отсюда такое не красивое условие
            if (error != nil || partners == nil) && self.reachability.connection == .none ||
                (partners != nil && partners!.count == 0 && self.reachability.connection == .none) {
                print("САМЫЙ ПЕРВЫЙ ВХОД В ПРИЛОЖЕНИЕ ПРОИЗОШЕЛ БЕЗ ИНТЕРНЕТА")
                let errorMessage = TinkoffError.furstTimeAuthorizationError.errorDescription
                self.output.didNotGetPartners(with: errorMessage)
                return
            }

            self.returnToView(partners, error: error)

            guard self.reachability.connection != .none else {
                DispatchQueue.main.async {
                    self.output.didGoOffline()
                }
                return
            }

            self.partnerService.getPartners { partners, error in
                guard
                    error == nil,
                    let partners = partners else {
                        return
                }
                self.coreDataService.savePartners(partners, completition: self.returnToView(_:error:))
            }
        }

    }

    private func returnToView(_ partners: [Partner]?, error: Error?) {
        guard
            error == nil,
            let partners = partners,
            partners.count > 0 else {
                return
        }
        let partnersPresentationInit = [PartnerPresentation](repeating: PartnerPresentation(),
                                                             count: partners.count)

        let partnersPresentation = PartnerMapper().map(partners, to: partnersPresentationInit)
        DispatchQueue.main.async {
            self.output.didGet(partnersPresentation)
        }
    }

    private func returnToViewWithCheckOfFirstEnter(_ partners: [Partner]?, error: Error?) {
        guard
            error == nil,
            let partners = partners,
            partners.count > 0 else {
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

        coreDataService.getPoints(for: coordinate,
                                  topRightCoordinate: topRightCordinate,
                                  bottomLeftCoordinate: bottomLeftCordinate,
                                  completition: returnToView(_:error:))

        if lastVisitedCoordinate == nil {
            lastVisitedCoordinate = coordinate
        }

        let locationFrom = CLLocation(latitude: lastVisitedCoordinate.latitude,
                                      longitude: lastVisitedCoordinate.longitude)
        let locationTo = CLLocation(latitude: coordinate.latitude,
                                    longitude: coordinate.longitude)
        let coordinatEdgeLocation = CLLocation(latitude: topRightCordinate.latitude,
                                               longitude: topRightCordinate.longitude)
        let coordinatCenterLocation = CLLocation(latitude: coordinate.latitude,
                                                 longitude: coordinate.longitude)

        let searchRadius = coordinatEdgeLocation.distance(from: coordinatCenterLocation)

        guard
            locationTo.distance(from: locationFrom) > searchRadius / 2.0 || isFirstLaunch else {
                DispatchQueue.main.async {
                    self.output.didFinishUpdating()
                }
                return
        }

        isFirstLaunch = false
        lastVisitedCoordinate = coordinate

        guard reachability.connection != .none else {
            return
        }

        pointService.getPoints(for: coordinate, with: searchRadius) { pointsJSON, error in

            guard
                error == nil,
                let pointsJSON = pointsJSON else {
                    return
            }

            guard !pointsJSON.isEmpty else {
                DispatchQueue.main.async {
                    print("ТОЧЕК В РАДИУСЕ ПОИСКА НЕТ")
                    self.output.didFinishUpdating()
                }
                return
            }

            self.coreDataService.savePoints(pointsJSON, completition: self.returnToView(_:error:))
        }
    }

    func tap(on point: PointPresentation) {
        coreDataService.getPartner(withId: point.partnerName) { partner, error in

            guard
                error == nil,
                let partner = partner else {
                    return
            }

            self.imageDownloadService.downloadImage(named: point.picture,
                                                      withLastModified: partner.pictureLastModified,
                                                      withPixelSize: "mdpi")
            { image, lastModified, error in

                guard
                    error == nil,
                    let image = image,
                    let lastModified = lastModified else {
                        return
                }

                DispatchQueue.main.async {
                    self.output.didLoad(image, for: point)
                }

                self.coreDataService.savePartner(withId: point.partnerName,
                                                 lastModified: lastModified) { _ in

                }
            }
        }
    }
}

extension PointsInteractor: LocationServiceDelegate {

    func didAuthorize() {
        DispatchQueue.main.async {
            self.output.didAuthorizeLocation()
        }
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
