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
    var info: String? {
        didSet {
            infoTextView.text = info
        }
    }

    @IBInspectable
    var image: UIImage? {
        didSet {
            roundView.image = image
        }
    }

    @IBOutlet weak var roundView: RoundButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var infoTextView: UITextView!

    override func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InfoView",
                        bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        infoTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    func setPartnerName(_ partnerName: String?) {
        label.text = partnerName
    }

    func setPartnerInfo(_ partnerInfo: String?) {

        // Тут тоже нужна проверка и по хорошему вынести все преобраования из HTML в разширение String
        let partnerInfo = "<b>Что взять с собой</b>: \(partnerInfo!)"
        let htmlData = NSString(string: partnerInfo).data(using: String.Encoding.unicode.rawValue)

        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]

        do {
            let attributedString = try NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
            infoTextView.attributedText = attributedString
        } catch {}
    }

    func set(_ image: UIImage) {
        roundView.image = image
    }
}
