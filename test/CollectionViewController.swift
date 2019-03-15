//
//  CollectionViewController.swift
//  test
//
//  Created by Валентина Маркова on 02/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


let request = RequestData()
var images: [UIImage] = []
let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)


class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for data in RequestData.imagesData {
            if let image = UIImage(data: data){
            images.append(image)
            }
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

//        if !RequestData.isPostsLoaded {
//
//            activityIndicator.center = CGPoint(x: collectionView.frame.size.width  / 2, y: (collectionView.frame.size.height / 2 - 60.0) )
//            activityIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            collectionView.addSubview(activityIndicator)
//            activityIndicator.startAnimating()
//
//            request.getRecentMedia (completion: { recievedData in
//                RequestData.savedData = recievedData
//                for index in RequestData.savedData.indices {
//                    RequestData.savedData[index].imageData = try? Data(contentsOf: (RequestData.savedData[index].imageURL!))
//                    if let imageData = RequestData.savedData[index].imageData {
//                        if let image = UIImage(data: imageData) {
//                            images.append(image)
//                        } else {
//                            images.append(#imageLiteral(resourceName: "noImage"))
//                        }
//                    }
//                }
//                self.collectionView.reloadData()
//                RequestData.isPostsLoaded = true
//                activityIndicator.stopAnimating()
//                activityIndicator.isHidden = true
//                activityIndicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            })
//        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {


        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        if let cell = cell as? CollectionViewCell {
            cell.collectionImageView.image = images[indexPath.row]
        }
        // Configure the cell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "CVSegue" {
                if let cell = sender as? CollectionViewCell {
                    let indexPath = collectionView.indexPath(for: cell)
                    let destination = segue.destination as? ImageViewController
                    
                    
                    destination?.image = images[(indexPath?.row)!]
                    destination?.profilePicture = RequestData.fetchImage(from: RequestData.tmpProfilePictureData, or: #imageLiteral(resourceName: "noImage"))
                    destination?.accountName = RequestData.savedData[((indexPath?.row)!)].accountName
                    destination?.location = RequestData.savedData[((indexPath?.row)!)].location
                    destination?.likes = RequestData.savedData[((indexPath?.row)!)].likes + " Likes"
                    destination?.id = RequestData.savedData[((indexPath?.row)!)].id
                    
                }
            }
        }
    }

    // MARK: UICollectionViewDelegate
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var item = CollectionViewCell()
//        performSegue(withIdentifier: "CVSegue", sender: item)
//    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
