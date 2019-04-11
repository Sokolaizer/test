
import UIKit

class CollectionViewController: UICollectionViewController {
  
  enum Constants {
    static let reuseIdentifier = "Cell"
    static let defaultLocation = "Location undefinded"
    static let logInSegueIdentifier = "logInSegue"
    static let cellSegueIdentifier = "CVSegue"
  }
  
  var thumbnails: [UIImage] = []
  var images: [UIImage?] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    for data in Store.thumbnailsData {
      guard let image = UIImage(data: data) else {return}
      thumbnails.append(image)
      images.append(nil)
    }
    DispatchQueue.global(qos: .background).async {
      for index in Store.mediaResponse.indices {
        guard let url = URL(string: Store.mediaResponse[index].images.standardResolution.url) else {return}
        do {
          let data = try Data(contentsOf: url)
          Store.photoData[index] = data
          guard let photo = UIImage(data: data) else {return}
          self.images[index] = photo
        } catch {
          print(error)
        }
      }
    }
    self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
  }
  
  @IBAction func logOut(_ sender: UIBarButtonItem) {
    Request.logOut()
    performSegue(withIdentifier: Constants.logInSegueIdentifier, sender: self)
  }
  
  // MARK: UICollectionViewDataSource
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return thumbnails.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
    if let cell = cell as? CollectionViewCell {
      cell.collectionImageView.image = thumbnails[indexPath.row]
    }
    return cell
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {return}
    switch identifier {
    case Constants.cellSegueIdentifier :
      guard let cell = sender as? CollectionViewCell else {return}
      let indexPath = collectionView.indexPath(for: cell)
      let destination = segue.destination as? PostViewController
      guard let index = indexPath?.row,
        let userPicData = Store.userPicData
        else {return}
      if let captionText = Store.mediaResponse[index].caption?.text {
        let username = Instagram.CommentsResponse.Comment.Person.init(username: Store.mediaResponse[index].user.username)
        let caption = Instagram.CommentsResponse.Comment.init(text: captionText, from: username)
        destination?.caption = caption
      }
      if let photo = images[index] {
        destination?.image = photo
      } else {
        destination?.image = thumbnails[index]
      }
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
