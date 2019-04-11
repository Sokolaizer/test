
import UIKit

class PhotoTableViewCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    photo.image = #imageLiteral(resourceName: "noImage")
  }
  
  @IBOutlet weak var photo: UIImageView!
}
