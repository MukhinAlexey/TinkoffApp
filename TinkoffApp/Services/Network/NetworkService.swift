import UIKit
import CoreData
import CoreLocation

enum NetworkRequestMethod {
    case POST
    case GET

    var string: String {
        switch self {
        case .POST:
            return "POST"
        case .GET:
            return "GET"
        }
    }
}

enum NetworkRequest {
    case points
    case partners
    case images
}

class NetworkService {

    let networkConfig: NetworkServiceConfig

    init(networkConfig: NetworkServiceConfig) {
        self.networkConfig = networkConfig
    }

    func makeCall(withMethod method: NetworkRequestMethod,
                  withRequest requestType: NetworkRequest,
                  withParameters parameters: String? = nil,
                  withCustomUrlSuffix customUrlSuffix: String? = nil,
                  completition: @escaping(Data?, Error?) -> Void) {

        var urlString = networkConfig.getUrl(for: requestType)

        if let customUrlSuffix = customUrlSuffix {
            urlString = urlString.appending(customUrlSuffix)
        }

        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method.string

        if parameters != nil {
            request.httpBody = parameters!.data(using: String.Encoding.utf8)
        }

        URLSession.shared.dataTask(with: request) { data, _, error in

            guard error == nil,
                let data = data else {
                    completition(nil, error)
                    return
            }
            completition(data, nil)
            }.resume()
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

    func makeCall(withMethod method: NetworkRequestMethod,
                  withRequest requestType: NetworkRequest,
                  withCustomUrlSuffix customUrlSuffix: String? = nil,
                  lastModified: String,
                  completition: @escaping(Data?, [AnyHashable: Any]?, Error?) -> Void) {

        var urlString = networkConfig.getUrl(for: requestType)

        if let customUrlSuffix = customUrlSuffix {
            urlString = urlString.appending(customUrlSuffix)
        }

        var request = URLRequest(url: URL(string: urlString)!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        request.httpMethod = method.string
        request.addValue(lastModified,
                         forHTTPHeaderField: "If-Modified-Since")

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
