import UIKit

class PartnerNetworkService {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getPartners(completition: @escaping ([[String:AnyObject]]?, Error?) -> Void) {
        networkService.makeCall(withMethod: .POST,
                                withRequest: .partners)
        { data, error  in

            guard
                error == nil,
                let data = data else {
                    completition(nil, TinkoffError.jsonSerializationError)
                    return
            }

            let (unwrapedJSONData, error) = self.networkService.JSONTransform(from: data)
            completition(unwrapedJSONData, error)
        }
    }
}
