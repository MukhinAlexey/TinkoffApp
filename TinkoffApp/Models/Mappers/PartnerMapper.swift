import UIKit

class PartnerMapper {

    func map(_ partner: Partner,
             to partnerPresentation: PartnerPresentation) -> PartnerPresentation {

        // Да, тут нужна проверка на опшинал
        let mappedPartnerPresentation = PartnerPresentation(id: partner.id!,
                                                            name: partner.name!,
                                                            picture: partner.picture!,
                                                            info: partner.info!)
        return mappedPartnerPresentation
    }

    func map(_ partners: [Partner],
             to partnersPresentation: [PartnerPresentation]) -> [PartnerPresentation] {
        guard partners.count == partnersPresentation.count else {
            return partnersPresentation
        }

        var mappedPartnersPresentation = [PartnerPresentation]()

        for partner in partners {
            let index = partners.index(of: partner)!
            let mappedPartnerPresentation = map(partner, to: partnersPresentation[index])
            mappedPartnersPresentation.append(mappedPartnerPresentation)
        }
        return mappedPartnersPresentation

    }
}
