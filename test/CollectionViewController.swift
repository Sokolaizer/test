//
//  CollectionViewController.swift
//  test
//
//  Created by Валентина Маркова on 02/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "Cell"
    
    let request = RequestData()
    var images: [UIImage] = []
    var photos: [UIImage?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for data in RequestData.imagesData {
            if let image = UIImage(data: data){
            images.append(image)
            photos.append(nil)
            }
        }
        DispatchQueue.global(qos: .background).async {
            
            for index in RequestData.mediaResponse.indices {
                if let url = URL(string: RequestData.mediaResponse[index].images.standardResolution.url) {
                    if let data = try? Data(contentsOf: url) {
                        RequestData.photoData.append(data)
                        if let photo = UIImage(data: data) {
                            self.photos[index] = photo
                        }
                    }
                }
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
        if let cell = cell as? CollectionViewCell {
            cell.collectionImageView.image = images[indexPath.row]
        }
        return cell
    }

    // move to router with push/present
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "CVSegue" {
                if let cell = sender as? CollectionViewCell {
                    let indexPath = collectionView.indexPath(for: cell)
                    let destination = segue.destination as? PostViewController
                    if let index = indexPath?.row {
                        if let photo = photos[index] {
                            destination?.image = photo
                        } else {
                            destination?.image = images[index]
                        }
                    }
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
}
