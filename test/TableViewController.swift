//
//  TableViewController.swift
//  test
//
//  Created by Валентина Маркова on 02/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "TVSegue" {
                if let cell = sender as? TableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    let destination = segue.destination as? PostViewController
                    
                    destination?.image = RequestData.fetchImage(from: RequestData.savedData[((indexPath?.row)!)].imageData, or: #imageLiteral(resourceName: "noImage"))
                    destination?.profilePicture = RequestData.fetchImage(from: RequestData.tmpProfilePictureData, or: #imageLiteral(resourceName: "noImage"))
                    destination?.accountName = RequestData.savedData[((indexPath?.row)!)].accountName
                    destination?.location = RequestData.savedData[((indexPath?.row)!)].location
                    destination?.likes = RequestData.savedData[((indexPath?.row)!)].likes + " Likes"
                    destination?.id = RequestData.savedData[((indexPath?.row)!)].id
                }
            }
        }
    }
}

extension TableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RequestData.savedData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        if let cell = cell as? TableViewCell {
            //            if let url = RequestData.tmpImagesData[indexPath.row] {
            let post = RequestData.savedData[indexPath.row]
            if let imageData = post.imageData {
                cell.igImage.image = UIImage(data: imageData)
            } else {
                cell.igImage.image = #imageLiteral(resourceName: "noImage")
            }
        }
        return cell
    }
}
