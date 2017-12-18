import UIKit

struct NetworkServiceConfig {

    var partnersURL: String
    var pointsURL: String
    var imagesURL: String

    func getUrl(for networkRequest: NetworkRequest) -> String {
        switch networkRequest {
        case .points:
            return pointsURL
        case .partners:
            return partnersURL
        case .images:
            return imagesURL
        }
    }
}
