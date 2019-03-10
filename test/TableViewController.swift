//
//  TableViewController.swift
//  test
//
//  Created by Валентина Маркова on 02/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    private var images = [String]()
    private var cellQuantity = SampleURLs.temporaryImageList.count
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        SampleURLs.getPhotos(completion: { images in
            self.images = images
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return cellQuantity
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "TVSegue" {
                if let cell = sender as? TableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    let destination = segue.destination as? ImageViewController
                    
                    if let url = SampleURLs.tmpImagesData[(indexPath?.row)!] {
                        let data = try? Data(contentsOf: url)
                        if let data = data {
                            destination?.image = UIImage(data: data) ?? #imageLiteral(resourceName: "noImage")
                            if let url = SampleURLs.tmpProfilePictureData {
                                let data = try? Data(contentsOf: url)
                                if let data = data {
                                    destination?.profilePicture = UIImage(data: data) ?? #imageLiteral(resourceName: "userPic")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        if let cell = cell as? TableViewCell {
            if let url = SampleURLs.tmpImagesData[indexPath.row] {
                let data = try? Data(contentsOf: url)
                if let data = data {
                cell.igImage.image = UIImage(data: data)
                } else {
                    cell.igImage.image = #imageLiteral(resourceName: "noImage")
                }
            }
        }

//        let data = try? Data(contentsOf: URL(fileURLWithSampleURLs.temporaryImageList)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
//        if let myTVCell = cell as? TableViewCell {
//            myTVCell.igImage.image = UIImage(data: data!)
//        }

        // Configure the cell...

        return cell
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
