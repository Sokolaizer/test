
import UIKit

class LikeTableViewCell: UITableViewCell {
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel! {
        didSet {
            likeCountLabel.text = "0 Likes"
        }
    }
}
