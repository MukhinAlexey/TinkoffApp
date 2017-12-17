import XCTest

class BalanceIncreaseModuleConfiguratorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testConfigureModuleForViewController() {

        //given
        let viewController = BalanceIncreaseViewControllerMock()
        let configurator = BalanceIncreaseModuleConfigurator()

        //when
        configurator.configureModuleForViewInput(viewInput: viewController)

        //then
        XCTAssertNotNil(viewController.output, "BalanceIncreaseViewController is nil after configuration")
        XCTAssertTrue(viewController.output is BalanceIncreasePresenter, "output is not BalanceIncreasePresenter")

        let presenter: BalanceIncreasePresenter = viewController.output as! BalanceIncreasePresenter
        XCTAssertNotNil(presenter.view, "view in BalanceIncreasePresenter is nil after configuration")
        XCTAssertNotNil(presenter.router, "router in BalanceIncreasePresenter is nil after configuration")
        XCTAssertTrue(presenter.router is BalanceIncreaseRouter, "router is not BalanceIncreaseRouter")

        let interactor: BalanceIncreaseInteractor = presenter.interactor as! BalanceIncreaseInteractor
        XCTAssertNotNil(interactor.output, "output in BalanceIncreaseInteractor is nil after configuration")
    }

    class BalanceIncreaseViewControllerMock: BalanceIncreaseViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
