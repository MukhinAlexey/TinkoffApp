import UIKit

class PointsModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {
        if let viewController = viewInput as? PointsViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: PointsViewController) {

        let presenter = PointsPresenter()
        presenter.view = viewController

        let networkServiceConfig = NetworkServiceConfig(partnersURL: AppConfig.partnersURL,
                                                        pointsURL: AppConfig.pointsURL,
                                                        imagesURL: AppConfig.downloadImagesURL)
        
        let networkService = NetworkService(networkConfig: networkServiceConfig)
        let partnerService = PartnerNetworkService(networkService: networkService)
        let pointService = PointNetworkService(networkService: networkService)

        let imageDownloaderConfig = ImageDownloadServiceConfig(downloadImagesURL: AppConfig.downloadImagesURL,
                                                               placeholderImageName: "ImagePlaceholder")
        let imageDownloaderService = ImageDownloadService(config: imageDownloaderConfig,
                                                            networkService: networkService)

        let locationService = LocationServiceImpl()

        let interactor = PointsInteractor()
        interactor.output = presenter
        interactor.imageDownloadService = imageDownloaderService
        interactor.partnerService = partnerService
        interactor.pointService = pointService
        interactor.locationService = locationService
        interactor.coreDataService = CoreDataService(coreDataStack: CoreDataStack())

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
