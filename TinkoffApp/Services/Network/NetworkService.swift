import UIKit
import CoreData
import CoreLocation

class NetworkService {

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

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard error == nil,
                let data = data else {
                    completition(nil, error)
                    return
            }
            
            completition(data, nil)
            }.resume()
    }

    func getPartners(completition: @escaping ([[String:AnyObject]]?, Error?) -> Void) {
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

    func makeCall(withMethod method: String,
                  toUrl urlString: String,
                  lastModified: String,
                  completition: @escaping(Data?, [AnyHashable: Any]?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: urlString)!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        request.httpMethod = method
        request.addValue(lastModified,
                         forHTTPHeaderField: "If-Modified-Since")

        print(request)

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard
                error == nil,
                let data = data,
                let response = response as? HTTPURLResponse else {
                    return completition(nil, nil, error)
            }
            if response.statusCode == 304 {
                return completition(nil, nil, nil)
            }
            let headers = response.allHeaderFields
            completition(data, headers, nil)
            }.resume()
    }

}
