//
//  TableViewController.swift
//  test
//
//  Created by Валентина Маркова on 02/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var images: [UIImage] = []
    var photos: [UIImage?] = []
    
    override func viewDidLoad() {
        for data in RequestData.imagesData {
            if let image = UIImage(data: data){
                images.append(image)
                photos.append(nil)
            }
        }
        for index in RequestData.photoData.indices {
            if let image = UIImage(data: RequestData.photoData[index]) {
                photos[index] = image
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "TVSegue" {
                if let cell = sender as? TableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    let destination = segue.destination as? PostViewController
                    
                    if let index = indexPath?.row {
                        if let photo = photos[index] {
                            destination?.image = photo
                        } else {
                            destination?.image = images[index]
                        }
                    }
                    
//                    destination?.image = RequestData.fetchImage(from: RequestData.savedData[((indexPath?.row)!)].imageData, or: #imageLiteral(resourceName: "noImage"))
                    destination?.profilePicture = RequestData.fetchImage(from: RequestData.tmpProfilePictureData, or: #imageLiteral(resourceName: "noImage"))
                    destination?.accountName = RequestData.mediaResponse[((indexPath?.row)!)].user.fullName
                    destination?.location = RequestData.mediaResponse[((indexPath?.row)!)].location?.name ?? "Location Undefinded"
                    destination?.likes = String (RequestData.mediaResponse[((indexPath?.row)!)].likes.count) + " Likes"
                    destination?.id = RequestData.mediaResponse[((indexPath?.row)!)].id
                    destination?.date =  RequestData.convertDate(from: RequestData.mediaResponse[((indexPath?.row)!)].createdTime)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RequestData.imagesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        if let cell = cell as? TableViewCell {
            let data = RequestData.imagesData[indexPath.row]
            if let image = UIImage(data: data) {
                cell.igImage.image = image
            } else {
                cell.igImage.image = #imageLiteral(resourceName: "noImage")
            }
        }
        return cell
    }
}
