
import UIKit

class TableViewController: UITableViewController {
  
  enum Constants {
    static let defaultImage = #imageLiteral(resourceName: "noImage")
    static let cellIdentifier = "tableCell"
    static let logInSegueIdentifier = "logInSegue"
    static let cellSegueIdentifier = "PostViewControllerSegue"
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
    guard let identifier = segue.identifier else {return}
    switch identifier {
    case Constants.cellSegueIdentifier :
      Navigation.toPostViewController(from: tableView, with: segue, sender: sender,  thumbnails: thumbnails, images: images)
    case Constants.logInSegueIdentifier:
      Navigation.toWebViewController(with: segue, sender: sender)
    default: break
    }
  }
  
  // MARK: - UITableViewDataSource
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
