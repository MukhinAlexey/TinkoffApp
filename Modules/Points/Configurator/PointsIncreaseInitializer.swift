import UIKit

class PointsModuleInitializer: NSObject {

    @IBOutlet weak var balanceincreaseViewController: PointsViewController!

    override func awakeFromNib() {
        let configurator = PointsModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: balanceincreaseViewController)
    }

}
