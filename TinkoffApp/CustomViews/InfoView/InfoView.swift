import UIKit

@IBDesignable
class InfoView: BaseView {

    @IBInspectable
    var text: String? {
        didSet {
            label.text = text
        }
    }

    @IBInspectable
    var image: UIImage? {
        didSet {
            roundView.image = image
        }
    }

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var roundView: RoundButton!

    override func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InfoView",
                        bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    func set(_ partnerName: String?) {
        label.text = partnerName
    }

    func set(_ image: UIImage) {
        roundView.image = image
    }
}
