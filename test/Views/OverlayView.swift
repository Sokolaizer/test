
import UIKit

class OverlayView: UIView {
  init() {
    super.init(frame: UIScreen.main.bounds)
    self.isHidden = true
    self.isOpaque = false
    self.backgroundColor = #colorLiteral(red: 0.1651594639, green: 0.1651594639, blue: 0.1651594639, alpha: 0.9252461473)
    self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
