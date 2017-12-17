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

        let networkServiceConfig = NetworkServiceConfig(partnersListURL: AppConfig.partnersURL,
                                                        pointsURL: AppConfig.pointsURL)
        let networkService = NetworkService(config: networkServiceConfig)

        let imageDownloaderConfig = ImageDownloadServiceConfig(downloadImagesURL: AppConfig.downloadImagesURL,
                                                               placeholderImageName: "ImagePlaceholder")
        let imageDownloaderService = ImageDownloadService(config: imageDownloaderConfig,
                                                            networkService: networkService)

        let locationService = LocationServiceImpl()

        let interactor = PointsInteractor()
        interactor.output = presenter
        interactor.imageDownloaderService = imageDownloaderService
        interactor.networkService = networkService
        interactor.locationService = locationService
        interactor.coreDataService = CoreDataService(coreDataStack: CoreDataStack())

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
