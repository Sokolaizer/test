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
    
    var thumbnails: [UIImage] = []
    var images: [UIImage?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for data in Request.thumbnailsData {
            if let image = UIImage(data: data){
            thumbnails.append(image)
            images.append(nil)
            }
        }
        DispatchQueue.global(qos: .background).async {
            for index in Request.mediaResponse.indices {
                if let url = URL(string: Request.mediaResponse[index].images.standardResolution.url) {
                    do{
                        let data = try Data(contentsOf: url)
                        Request.photoData.append(data)
                        if let photo = UIImage(data: data) {
                            self.images[index] = photo
                        }
                    } catch {
                        print("URl doesn't contents data")
                    }
                }
            }
        }
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "logInSegue", sender: self)
        Request.logOut()
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
        if let cell = cell as? CollectionViewCell {
            cell.collectionImageView.image = thumbnails[indexPath.row]
        }
        return cell
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "CVSegue" {
                if let cell = sender as? CollectionViewCell {
                    let indexPath = collectionView.indexPath(for: cell)
                    let destination = segue.destination as? PostViewController
                    if let index = indexPath?.row {
                        if let captionText = Request.mediaResponse[index].caption?.text {
                            let username = Instagram.CommentsResponse.Comment.Person.init(username: Request.mediaResponse[index].user.username)
                            let caption = Instagram.CommentsResponse.Comment.init(text: captionText, from: username)
                        destination?.caption = caption
                        }
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
}
