
import UIKit

class TableViewController: UITableViewController {
  
  enum Constants {
    static let defaultImage = #imageLiteral(resourceName: "noImage")
    static let cellIdentifier = "tableCell"
    static let logInSegueIdentifier = "logInSegue"
    static let cellSegueIdentifier = "PostViewControllerSegue"
  }
  var photos: [Photo] = []
  
  override func viewDidLoad() {
    for data in Store.thumbnailsData {
      guard let thumbnail = UIImage(data: data) else {return}
      photos.append(Photo(thumbnail: thumbnail))
    }
    for index in Store.imagesData.indices {
      guard let image = UIImage(data: Store.imagesData[index] ?? Store.thumbnailsData[index]) else {return}
      photos[index].image = image
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
      Navigation.toPostViewController(from: tableView, with: segue, sender: sender, photos: photos)
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
    guard let tableViewCell = cell as? TableViewCell else {return cell}
    let data: Data
    if Store.imagesData[indexPath.row] != nil {
      data = Store.imagesData[indexPath.row]!
    } else {
      data = Store.thumbnailsData[indexPath.row]
    }
    if let image = UIImage(data: data) {
      tableViewCell.photo.image = image
    } else {
      tableViewCell.photo.image = Constants.defaultImage
    }
    return tableViewCell
  }
}
