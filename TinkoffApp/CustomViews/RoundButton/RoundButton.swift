import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
        }
    }

    @IBInspectable var color: UIColor? {
        didSet {
            backgroundColor = color
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2
        clipsToBounds = true
    }
}
