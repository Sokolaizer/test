
import UIKit

class CollectionViewController: UICollectionViewController {
  
  enum Constants {
    static let reuseIdentifier = "Cell"
    static let logInSegueIdentifier = "logInSegue"
    static let cellSegueIdentifier = "PostViewControllerSegue"
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
        guard Store.mediaResponse.count > index else {return}
        guard let url = URL(string: Store.mediaResponse[index].images.standardResolution.url) else {return}
        do {
          let data = try Data(contentsOf: url)
          guard Store.photoData.count > index else {return}
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
      Navigation.toPostViewController(from: collectionView, with: segue, sender: sender,  thumbnails: thumbnails, images: images) 
    case Constants.logInSegueIdentifier:
      Navigation.toWebViewController(with: segue, sender: sender)
    default: break
    }
  }
}
