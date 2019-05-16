
import UIKit

class CollectionViewController: UICollectionViewController {
  
  enum Constants {
    static let reuseIdentifier = "Cell"
    static let logInSegueIdentifier = "logInSegue"
    static let cellSegueIdentifier = "PostViewControllerSegue"
  }
  var photos: [Photo] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    for data in Store.thumbnailsData {
      guard let thumbnail = UIImage(data: data) else {return}
      photos.append(Photo(thumbnail: thumbnail))
    }
    Store.getImagesData { data, index in
      guard let photo = UIImage(data: data) else {return}
      self.photos[index].image = photo
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
    return photos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
    guard let collectionViewCell = cell as? CollectionViewCell else {return cell}
    collectionViewCell.collectionImageView.image = photos[indexPath.row].thumbnail
    return collectionViewCell
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {return}
    switch identifier {
    case Constants.cellSegueIdentifier :
      Navigation.toPostViewController(from: collectionView, with: segue, sender: sender, photos: photos)
    case Constants.logInSegueIdentifier:
      Navigation.toWebViewController(with: segue, sender: sender)
    default: break
    }
  }
}
