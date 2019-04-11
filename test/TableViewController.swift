
import UIKit

class TableViewController: UITableViewController {
  
  enum Constants {
    static let defaultUserPic = #imageLiteral(resourceName: "userPic")
    static let defaultImage = #imageLiteral(resourceName: "noImage")
    static let defaultLocation = "Location undefinded"
    static let cellIdentifier = "tableCell"
    static let logInSegueIdentifier = "logInSegue"
    static let cellSegueIdentifier = "TVSegue"
  }
  
  var thumbnails: [UIImage] = []
  var images: [UIImage?] = []
  
  override func viewDidLoad() {
    for data in Store.thumbnailsData {
      guard let image = UIImage(data: data) else {return}
      thumbnails.append(image)
      images.append(nil)
    }
    for index in Store.photoData.indices {
      guard let image = UIImage(data: Store.photoData[index] ?? Store.thumbnailsData[index]) else {return}
      images[index] = image
    }
  }
  
  @IBAction func logOut(_ sender: UIBarButtonItem) {
    Request.logOut()
    performSegue(withIdentifier: Constants.logInSegueIdentifier, sender: self)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case Constants.cellSegueIdentifier :
        guard let cell = sender as? TableViewCell else {return}
        let indexPath = tableView.indexPath(for: cell)
        let destination = segue.destination as? PostViewController
        guard let index = indexPath?.row else {return}
        guard let captionText = Store.mediaResponse[index].caption?.text else {return}
        let username = Instagram.CommentsResponse.Comment.Person.init(username: Store.mediaResponse[index].user.username)
        let caption = Instagram.CommentsResponse.Comment.init(text: captionText, from: username)
        destination?.caption = caption
        if let photo = images[index] {
          destination?.image = photo
        } else {
          destination?.image = thumbnails[index]
        }
        guard let userPicData = Store.userPicData else {return}
        destination?.profilePicture = UIImage(data: userPicData) ?? #imageLiteral(resourceName: "userPic")
        destination?.accountName = Store.mediaResponse[index].user.fullName
        destination?.location = Store.mediaResponse[index].location?.name ?? Constants.defaultLocation
        destination?.likes = String (Store.mediaResponse[index].likes.count) + " Likes"
        destination?.id = Store.mediaResponse[index].id
        destination?.date =  Request.convertDate(from: Store.mediaResponse[index].createdTime)
      case Constants.logInSegueIdentifier:
        let destnation = segue.destination as? WebViewController
        destnation?.isNeedAuthentication = true
      default: break
      }
    }
  }
  
  // MARK: - Table View Data Source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Store.thumbnailsData.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
    if let cell = cell as? TableViewCell {
      let data: Data
      if Store.photoData[indexPath.row] != nil {
        data = Store.photoData[indexPath.row]!
      } else {
        data = Store.thumbnailsData[indexPath.row]
      }
      if let image = UIImage(data: data) {
        cell.photo.image = image
      } else {
        cell.photo.image = Constants.defaultImage
      }
    }
    return cell
  }
}
