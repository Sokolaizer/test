//
//  TableViewController.swift
//  test
//
//  Created by Валентина Маркова on 02/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var thumbnails: [UIImage] = []
    var images: [UIImage?] = []
    
    override func viewDidLoad() {
        for data in Request.thumbnailsData {
            if let image = UIImage(data: data){
                thumbnails.append(image)
                images.append(nil)
            }
        }
        for index in Request.photoData.indices {
            if let image = UIImage(data: Request.photoData[index]) {
                images[index] = image
            }
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "logInSegue", sender: self)
        Request.logOut()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "TVSegue" {
                if let cell = sender as? TableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    let destination = segue.destination as? PostViewController
                    
                    if let index = indexPath?.row {
                        if let photo = images[index] {
                            destination?.image = photo
                        } else {
                            destination?.image = thumbnails[index]
                        }
                    }
                    destination?.profilePicture = Request.fetchImage(from: Request.profilePictureData, or: #imageLiteral(resourceName: "noImage"))
                    destination?.accountName = Request.mediaResponse[((indexPath?.row)!)].user.fullName
                    destination?.location = Request.mediaResponse[((indexPath?.row)!)].location?.name ?? "Location Undefinded"
                    destination?.likes = String (Request.mediaResponse[((indexPath?.row)!)].likes.count) + " Likes"
                    destination?.id = Request.mediaResponse[((indexPath?.row)!)].id
                    destination?.date =  Request.convertDate(from: Request.mediaResponse[((indexPath?.row)!)].createdTime)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Request.thumbnailsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        if let cell = cell as? TableViewCell {
            let data = Request.thumbnailsData[indexPath.row]
            if let image = UIImage(data: data) {
                cell.photo.image = image
            } else {
                cell.photo.image = #imageLiteral(resourceName: "noImage")
            }
        }
        return cell
    }
}
