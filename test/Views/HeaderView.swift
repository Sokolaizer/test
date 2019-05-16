
import UIKit

class HeaderView: UIView {
  enum Constants {
    static let likeImageViewHeight: CGFloat = 32.0
    static let space: CGFloat = 5.0
    static let heightSpace: CGFloat = 42.0
    static let likeLabelFontSize: CGFloat = 17.0
    static let dateLabelFontSize: CGFloat = 13.0
  }
  
  let postImageView: PostImageView
  let likeImageView: UIImageView
  let likeLabel: UILabel
  let dateLabel: UILabel
  let tableView: UITableView
  
  func setConstraints() {
    let constraints = [
      postImageView.topAnchor.constraint(equalTo: tableView.topAnchor),
      postImageView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
      postImageView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
      postImageView.heightAnchor.constraint(equalTo: tableView.widthAnchor),
      postImageView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
      likeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      likeImageView.widthAnchor.constraint(equalToConstant: Constants.likeImageViewHeight),
      likeImageView.heightAnchor.constraint(equalToConstant: Constants.likeImageViewHeight),
      likeImageView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: CGFloat(Constants.space)),
      likeLabel.leadingAnchor.constraint(equalTo: likeImageView.trailingAnchor, constant: Constants.space),
      likeLabel.trailingAnchor.constraint(greaterThanOrEqualTo: tableView.trailingAnchor, constant: Constants.space),
      likeLabel.trailingAnchor.constraint(greaterThanOrEqualTo: dateLabel.leadingAnchor, constant: Constants.space),
      likeLabel.centerYAnchor.constraint(equalTo: likeImageView.centerYAnchor),
      dateLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
      dateLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: Constants.space)
    ]
    NSLayoutConstraint.activate(constraints)
    postImageView.translatesAutoresizingMaskIntoConstraints = false
    likeImageView.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    likeLabel.translatesAutoresizingMaskIntoConstraints = false
  }
  
  init(with image: UIImage, asTableHeaderViewIn tableView: UITableView, like: String, date: String, delegate: UIGestureRecognizerDelegate, navController: UINavigationController?, tabBarController: UITabBarController?) {
    self.tableView = tableView
    postImageView = PostImageView(with: image, asTableHeaderViewIn: tableView, navController: navController, tabBarController: tabBarController)
    likeLabel = UILabel(frame: .zero)
    dateLabel = UILabel(frame: .zero)
    likeLabel.text = like
    likeLabel.font = .systemFont(ofSize: Constants.likeLabelFontSize, weight: .medium)
    dateLabel.text = date
    dateLabel.font = .systemFont(ofSize: Constants.dateLabelFontSize, weight: .thin)
    dateLabel.textColor = .darkGray
    likeImageView = UIImageView(image: #imageLiteral(resourceName: "like"))
    super.init(frame: .zero)
    tableView.tableHeaderView = self
    self.addSubview(likeLabel)
    self.addSubview(dateLabel)
    self.addSubview(likeImageView)
    self.addSubview(postImageView.overlayView)
    self.addSubview(postImageView)
    guard let superview = superview else {return}
    let headerViewConstraints = [
      self.topAnchor.constraint(equalTo: superview.topAnchor),
      self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      self.heightAnchor.constraint(equalTo: superview.widthAnchor, constant: Constants.heightSpace)
    ]
    NSLayoutConstraint.activate(headerViewConstraints)
    self.translatesAutoresizingMaskIntoConstraints = false
    postImageView.setGestures(tableView: tableView, delegate: delegate)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
