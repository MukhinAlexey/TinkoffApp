import UIKit
import CoreData
import CoreLocation

class NetworkService: NSObject {

    private let partnersListURL: String
    private let pointsURL: String

    init(config: NetworkServiceConfig) {
        partnersListURL = config.partnersListURL
        pointsURL = config.pointsURL
    }

    private func makeCall(withMethod method: String,
                          toUrl urlString: String,
                          withParameters parameters: String,
                          completition: @escaping(Data?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let session = URLSession.shared

        session.dataTask(with: request) { data, response, error in

            guard error == nil, let data = data else {
                completition(nil, error)
                return
            }
            completition(data, nil)
            }.resume()
    }

    func getPartnersList(completition: @escaping ([[String:AnyObject]]?, Error?) -> Void) {
        makeCall(withMethod: "POST",
                 toUrl: partnersListURL,
                 withParameters: "")
        { data, error in

            guard
                error == nil,
                let data = data else {
                    completition(nil, TinkoffError.jsonSerializationError)
                    return
            }

            let (unwrapedJSONData, error) = self.JSONTransform(from: data)
            completition(unwrapedJSONData, error)
        }
    }

    func getPoints(for coordinates: CLLocationCoordinate2D,
                   with searchRadius: CLLocationDistance,
                   completition: @escaping ([[String:AnyObject]]?, Error?) -> Void) {

        let parameters = "latitude=\(coordinates.latitude)&longitude=\(coordinates.longitude)&radius=\(Int(searchRadius))"

        makeCall(withMethod: "POST",
                 toUrl: pointsURL,
                 withParameters: parameters)
        { data, error in

            guard
                error == nil,
                let data = data else {
                    completition(nil, TinkoffError.jsonSerializationError)
                    return
            }

            let (unwrapedJSONData, error) = self.JSONTransform(from: data)

            completition(unwrapedJSONData, error)
        }
    }

    func JSONTransform(from data: Data) -> ([[String: AnyObject]]?, Error?) {
        var json: [String: AnyObject]?
        do {
            json = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject]
        } catch {
            return (nil, error)
        }

        guard
            let JSONDataNotNil = json,
            let unwrapedJSONDataNotNil = JSONDataNotNil["payload"],
            let unwrapedJSONDataNotNilArray = unwrapedJSONDataNotNil as? [[String:AnyObject]] else {
                return (nil, TinkoffError.jsonSerializationError)
        }

        return (unwrapedJSONDataNotNilArray, nil)
    }
}
