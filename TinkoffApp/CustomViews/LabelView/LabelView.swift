import UIKit

@IBDesignable
class LabelView: BaseView {

    @IBInspectable
    var text: String? {
        didSet {
            label.text = text
        }
    }

    @IBOutlet weak var label: UILabel!

    override func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LabelView",
                        bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = bounds.height / 2
    }

    func set(_ statusText: String) {
        label.text = statusText
    }

}
