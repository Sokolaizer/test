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
    var photos: [(isLoaded: Bool, photo: UIImage?)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for data in RequestData.imagesData {
            if let image = UIImage(data: data){
            images.append(image)
                photos.append((isLoaded: false, photo: nil))
                print("small photo loaded")
                
            }
        }
        DispatchQueue.global(qos: .background).async {
            for index in RequestData.savedData.indices{
                if !self.photos[index].isLoaded {
                    if let url = URL(string: RequestData.savedData[index].photoString)  {
                        if let data = try? Data(contentsOf: url) {
                            if let photo = UIImage(data: data) {
                                print("photo \(index) loaded")
                                self.photos[index] = (isLoaded: true, photo: photo)
                            }
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
                    if photos[index].isLoaded {
                    destination?.image = photos[index].photo ?? images[(indexPath?.row)!]
                    } else {
                        destination?.image = images[index]
                        }
                    }
                    
                    destination?.profilePicture = RequestData.fetchImage(from: RequestData.tmpProfilePictureData, or: #imageLiteral(resourceName: "noImage"))
                    destination?.accountName = RequestData.savedData[((indexPath?.row)!)].accountName
                    destination?.location = RequestData.savedData[((indexPath?.row)!)].location
                    destination?.likes = RequestData.savedData[((indexPath?.row)!)].likes + " Likes"
                    destination?.id = RequestData.savedData[((indexPath?.row)!)].id
                    destination?.date = RequestData.savedData[((indexPath?.row)!)].createdTimeString
                }
            }
        }
    }
}
