import UIKit

@IBDesignable
class BaseView: UIView {

    var view: UIView!
    var didLoad = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }

    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        preconditionFailure("This method must be overridden")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !didLoad {
            viewDidLoad()
        }
    }

    func viewDidLoad() {
        didLoad = true
    }
}
