
import UIKit
struct Photo {
  var image: UIImage?
  var thumbnail: UIImage
    
  init(thumbnail: UIImage) {
    self.thumbnail = thumbnail
    self.image = nil
  }
}
