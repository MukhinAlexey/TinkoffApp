import UIKit

class PartnerToPresentation {

    func map(partner: Partner,
             partnerPresentation: inout PartnerPresentation) -> PartnerPresentation {
        //partnerPresentation.id = partner.id
        //partnerPresentation.name = partner.name
        //partnerPresentation.picture = partner.picture
        return partnerPresentation
    }

    func mapArrays(partners: [Partner],
                   partnersPresentation: inout [PartnerPresentation]) -> [PartnerPresentation] {
        guard partners.count == partnersPresentation.count else {
            return partnersPresentation
        }

        // Так себе идея
        var index = 0
        for partner in partners {
            partnersPresentation[index] = map(partner: partner,
                                              partnerPresentation: &partnersPresentation[index])
            index += 1
        }
        return partnersPresentation
    }
}
