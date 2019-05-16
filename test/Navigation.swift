
import UIKit

struct Navigation {
  
  enum Constants {
    static let defaultLocation = "Location undefinded"
    static let webSegueIdentifier = "WebSegue"

  }
  
  static func toWebViewController( with segue: UIStoryboardSegue, sender: Any?) {
        let destnation = segue.destination as? WebViewController
        destnation?.isNeedAuthentication = true
    }
  
  static func toCollectionViewController (from viewController: UIViewController) {
    guard let webViewController = viewController as? WebViewController else {return}
    webViewController.web.isHidden = true
    Request.getRecentMedia (completion: { mediaResponse in
      Request.saveRecentMedia(from: mediaResponse)
      webViewController.performSegue(withIdentifier: Constants.webSegueIdentifier, sender: self)
    })
  }
  
  static func toPostViewController (from tableView: UITableView, with segue: UIStoryboardSegue, sender: Any?, photos: [Photo]) {
    guard let cell = sender as? TableViewCell else {return}
    let indexPath = tableView.indexPath(for: cell)
    let destination = segue.destination as? PostViewController
    guard let index = indexPath?.row else {return}
    setUpPostViewController(index: index, destination: destination, photos: photos)
  }
  
  static func toPostViewController (from collectionView: UICollectionView, with segue: UIStoryboardSegue, sender: Any?, photos: [Photo]) {
    guard let cell = sender as? CollectionViewCell else {return}
    let indexPath = collectionView.indexPath(for: cell)
    let destination = segue.destination as? PostViewController
    guard let index = indexPath?.row else {return}
    setUpPostViewController(index: index, destination: destination, photos: photos)
  }
  
  static func setUpPostViewController(index: Int, destination: PostViewController?, photos: [Photo]) {
    if let captionText = Store.mediaResponse[index].caption?.text {
      let username = Instagram.CommentsResponse.Comment.Person.init(username: Store.mediaResponse[index].user.username)
      let caption = Instagram.CommentsResponse.Comment.init(text: captionText, from: username)
      destination?.caption = caption
    }
    if let photo = photos[index].image {
      destination?.image = photo
    } else {
      destination?.image = photos[index].thumbnail
    }
    guard let userPicData = Store.userPicData else {return}
    destination?.profilePicture = UIImage(data: userPicData) ?? #imageLiteral(resourceName: "userPic")
    destination?.accountName = Store.mediaResponse[index].user.fullName
    destination?.location = Store.mediaResponse[index].location?.name ?? Constants.defaultLocation
    destination?.likes = String (Store.mediaResponse[index].likes.count) + " Likes"
    destination?.id = Store.mediaResponse[index].id
    destination?.date =  Request.convertDate(from: Store.mediaResponse[index].createdTime)
  }
  }
