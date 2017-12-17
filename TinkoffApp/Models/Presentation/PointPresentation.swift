import UIKit
import CoreLocation
import GoogleMaps

class PointPresentation {

    var coordinate: CLLocationCoordinate2D!
    //var addressInfo: String?
    //var fullAddress: String?
    var partnerName: String!
    //var phone: String?
    //var workHours: String?
    //var balanceIncreasePointToPartner: Partner?
    var marker: GMSMarker?

    init() {}

    init(partnerName: String,
         coordinate: CLLocationCoordinate2D) {
        self.partnerName = partnerName
        self.coordinate = coordinate
    }
}
