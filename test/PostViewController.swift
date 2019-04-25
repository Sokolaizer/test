
import UIKit

class PostViewController: UIViewController {
  
  enum Constants {
    static let sectionCount = 1
    static let likeCellIndexPath = (section: 0, row: 0)
    static let commentsCellIndexPathSection = 0
    static let commentFontSize: CGFloat = 14.0
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
  var caption: Instagram.CommentsResponse.Comment?

  private var comments: [Instagram.CommentsResponse.Comment] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Request.getRecentComments(id: id) { comments in
      if let caption = self.caption {
        self.comments = [caption] + comments
      } else {
        self.comments = comments
      }
      self.photoTableView.reloadSections(IndexSet(integer: Constants.commentsCellIndexPathSection), with: .fade)
    }
    userPic.image = profilePicture
    userPic.setUp()
    accountNameLabel.text = accountName
    locationLabel.text = location
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    headerView = HeaderView(with: image, asTableHeaderViewIn: photoTableView, like: likes, date: date, delegate: self, fadeView: fadeView, navController: self.navigationController)
    photoTableView.addSubview(headerView)
    headerView.setConstraints()
  }

  @IBOutlet weak var photoTableView: UITableView!{
    didSet {
      photoTableView.dataSource = self
    }
  }
  
  @IBOutlet weak private var userPic: UserImageView!
  @IBOutlet weak private var accountNameLabel: UILabel!
  @IBOutlet weak private var locationLabel: UILabel!
  @IBOutlet weak var fadeView: UIView!
  var headerView: HeaderView!
  
  @IBAction func logOut(_ sender: UIBarButtonItem) {
    Request.logOut()
    performSegue(withIdentifier: Constants.logInSegueIdentifier, sender: self)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {return}
    if identifier == identifier {
    Navigation.toWebViewController(with: segue, sender: sender)
    }
  }
}

// MARK: - UIGestureRecognizerDelegate
extension PostViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

//MARK: - UITableViewDataSource
extension PostViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Constants.sectionCount
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.commentCellIdentifier, for: indexPath)
    if let cell = cell as? CommentTableViewCell {
      let attributedUserString = NSMutableAttributedString(string:( comments[indexPath.row].from.username + "  "), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Constants.commentFontSize, weight: .medium)])
      let attributedCommentString = NSMutableAttributedString(string: comments[indexPath.row].text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Constants.commentFontSize, weight: .light)])
      attributedUserString.append(attributedCommentString)
      cell.commentLabel.attributedText = attributedUserString
    }
    return cell
  }
}
