
import UIKit

class UserImageView: UIImageView {
  
  enum Constants {
    static let userPicBorderWidth: CGFloat = 0.5
    static let userPicBorderColor: CGColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  }

  func setUp() {
    self.layer.borderWidth = Constants.userPicBorderWidth
    self.layer.masksToBounds = false
    self.layer.borderColor = Constants.userPicBorderColor
    self.layer.cornerRadius = self.frame.height/2
    self.clipsToBounds = true
  }
}
