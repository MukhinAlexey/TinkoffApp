import UIKit

class PartnerPresentation {

    var id: String!
    var name: String!
    var picture: String!
    // var url: String!

    //var depositionDuration: String
    //var hasLocations: Bool
    //var isMomentary: Bool
    //var limitations: String
    //var pointType: String

    init() {}

    init(id: String,
         name: String,
         picture: String) {
        self.id = id
        self.name = name
        self.picture = picture
    }

    init(id: String,
         name: String,
         picture: String,
         url: String,
         depositionDuration: String,
         hasLocations: Bool,
         isMomentary: Bool,
         limitations: String,
         pointType: String) {
        self.id = id
        self.name = name
        self.picture = picture
    }
}
