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

        let imageDownloaderConfig = ImageDownloaderServiceConfig(downloadImagesURL: AppConstant.downloadImagesURL)
        let imageDownloaderService = ImageDownloaderService(config: imageDownloaderConfig)

        let networkServiceConfig = NetworkServiceConfig(partnersListURL: AppConstant.partnersURL,
                                                        pointsURL: AppConstant.pointsURL)
        let networkService = NetworkService(config: networkServiceConfig)

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
