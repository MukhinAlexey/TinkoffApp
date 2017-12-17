import UIKit

@IBDesignable
class InfoView: BaseView {

    @IBOutlet weak var label: UILabel!

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
}
