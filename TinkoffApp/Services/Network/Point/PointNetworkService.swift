import UIKit
import CoreLocation

class PointNetworkService {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getPoints(for coordinates: CLLocationCoordinate2D,
                   with searchRadius: CLLocationDistance,
                   completition: @escaping ([[String:AnyObject]]?, Error?) -> Void) {

        let parameters = "latitude=\(coordinates.latitude)&longitude=\(coordinates.longitude)&radius=\(Int(searchRadius))"

        networkService.makeCall(withMethod: .POST,
                                withRequest: .points,
                                withParameters: parameters)
        { data, error in

            guard
                error == nil,
                let data = data else { 
                    completition(nil, TinkoffError.jsonSerializationError)
                    return
            }

            print(data)

            let (unwrapedJSONData, error) = self.networkService.JSONTransform(from: data)

            completition(unwrapedJSONData, error)
        }
    }
}
