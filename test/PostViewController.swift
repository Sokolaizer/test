
import UIKit

class PostViewController: UIViewController {
  
  enum Constants {
    static let sectionCount = 3
    static let photoCellIndexPath = (section: 0, row: 0)
    static let likeCellIndexPath = (section: 1, row: 0)
    static let commentsCellIndexPathSection = 2
    static let commentFontSize: CGFloat = 14.0
    static let fadeViewBackgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8218107877)
    static let userPicBorderWidth: CGFloat = 0.5
    static let userPicBorderColor: CGColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let minimumZoomScale: CGFloat = 1.0
    static let maximumZoomScale: CGFloat = 1.8
    static let photoCellIdentifier = "photoCell"
    static let likeCellIdentifier = "likeCell"
    static let commentCellIdentifier = "commentCell"
    static let logInSegueIdentifier = "logInSegue"
  }
  
  var image = #imageLiteral(resourceName: "noImage")
  var profilePicture = #imageLiteral(resourceName: "userPic")
  var accountName = "Account Name"
  var location = "Location undefined"
  var likes = "0 Likes"
  var id = ""
  var date = ""
  var caption :Instagram.CommentsResponse.Comment?
  
  var isCommentsAnimationIsEnded = false
  
  private var comments: [Instagram.CommentsResponse.Comment] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userPic.image = profilePicture
    accountNameLabel.text = accountName
    locationLabel.text = location
    
    userPic.layer.borderWidth = Constants.userPicBorderWidth
    userPic.layer.masksToBounds = false
    userPic.layer.borderColor = Constants.userPicBorderColor
    userPic.layer.cornerRadius = userPic.frame.height/2
    userPic.clipsToBounds = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    Request.getRecentComments(id: id) { comments in
      if let caption = self.caption {
        self.comments = [caption] + comments
      } else {
        self.comments = comments
      }
      self.photoTableView.performBatchUpdates({self.photoTableView.reloadSections(IndexSet(integer: IndexSet.Element(Constants.commentsCellIndexPathSection)), with: UITableView.RowAnimation.fade)}, completion: {
        (finished) in
        if finished {
          self.isCommentsAnimationIsEnded = true
        }
      })
    }
  }
  
  @IBOutlet weak var photoTableView: UITableView!{
    didSet {
      photoTableView.minimumZoomScale = Constants.minimumZoomScale
      photoTableView.maximumZoomScale = Constants.maximumZoomScale
      photoTableView.dataSource = self
      photoTableView.delegate = self
    }
  }
  
  @IBOutlet weak private var userPic: UIImageView!
  @IBOutlet weak private var accountNameLabel: UILabel!
  @IBOutlet weak private var locationLabel: UILabel!
  @IBOutlet weak var fadeView: UIView! {
    didSet {
      fadeView.isHidden = true
    }
  }
  
  @IBAction func logOut(_ sender: UIBarButtonItem) {
    Request.logOut()
    performSegue(withIdentifier: Constants.logInSegueIdentifier, sender: self)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {return}
    if identifier == Constants.logInSegueIdentifier {
      let destnation = segue.destination as? WebViewController
      destnation?.isNeedAuthentication = true
    }
  }
}

// MARK: - UIScrollViewDelegate
extension PostViewController: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    if isCommentsAnimationIsEnded {
      return photoTableView.cellForRow(at: .init(row: Constants.photoCellIndexPath.row, section: Constants.photoCellIndexPath.section))
    } else {
      return nil
    }
  }
  
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    scrollView.setZoomScale(Constants.minimumZoomScale, animated: true)
    photoTableView.cellForRow(at: .init(row: Constants.likeCellIndexPath.row, section: Constants.likeCellIndexPath.section))?.isHidden = false
    for row in comments.indices {
      photoTableView.cellForRow(at: IndexPath(row: row, section: Constants.commentsCellIndexPathSection))?.isHidden = false
    }
    fadeView.isHidden = true
    scrollView.clipsToBounds = true
  }
  
  func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    fadeView.isHidden = false
    photoTableView.cellForRow(at: .init(row: Constants.likeCellIndexPath.row, section: Constants.likeCellIndexPath.section))?.isHidden = true
    for row in comments.indices {
      photoTableView.cellForRow(at: IndexPath(row: row, section: Constants.commentsCellIndexPathSection))?.isHidden = true
    }
    fadeView.backgroundColor =  Constants.fadeViewBackgroundColor
    scrollView.clipsToBounds = false
  }
}

//MARK: - UITableViewDataSource
extension PostViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Constants.sectionCount
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = section != Constants.commentsCellIndexPathSection ? 1 : comments.count
    return numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let prototype: String
    switch indexPath.section {
    case Constants.photoCellIndexPath.section:
      prototype = Constants.photoCellIdentifier
    case Constants.likeCellIndexPath.section:
      prototype = Constants.likeCellIdentifier
    default:
      prototype = Constants.commentCellIdentifier
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath)
    if let cell = cell as? PhotoTableViewCell {
      cell.photo.image = image
    } else if let cell = cell as? LikeTableViewCell {
      cell.likeCountLabel.text = likes
      cell.createdTime.text = date
    } else if let cell = cell as? CommentTableViewCell {
      let attributedUserString = NSMutableAttributedString(string:( comments[indexPath.row].from.username + "  "), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Constants.commentFontSize, weight: .medium)])
      let attributedCommentString = NSMutableAttributedString(string: comments[indexPath.row].text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Constants.commentFontSize, weight: .light)])
      attributedUserString.append(attributedCommentString)
      cell.commentLabel.attributedText = attributedUserString
    }
    return cell
  }
}

// MARK: - UITableViewDelegate
extension PostViewController: UITableViewDelegate {
}
