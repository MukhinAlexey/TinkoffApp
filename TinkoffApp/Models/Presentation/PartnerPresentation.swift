import UIKit

class PartnerPresentation {

    var id: String!
    var name: String!
    var picture: String!
    var info: String!
    // var url: String!

    //var depositionDuration: String
    //var hasLocations: Bool
    //var isMomentary: Bool
    //var limitations: String
    //var pointType: String

    init() {}

    init(id: String,
         name: String,
         picture: String,
         info: String) {
        self.id = id
        self.name = name
        self.picture = picture
        self.info = info
    }
}
