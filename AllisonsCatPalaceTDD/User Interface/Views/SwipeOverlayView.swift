import UIKit
import Koloda

class SwipeOverlayView: OverlayView {

    @IBOutlet weak var imageView: UIImageView!

    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                imageView.image = #imageLiteral(resourceName: "noOverlayImage")
            case .right? :
                imageView.image = #imageLiteral(resourceName: "yesOverlayImage")
            default:
                imageView.image = nil
            }
        }
    }
}
