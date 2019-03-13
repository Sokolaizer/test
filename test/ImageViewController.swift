//
//  ImageViewController.swift
//  test
//
//  Created by Валентина Маркова on 08/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController , UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    var image = #imageLiteral(resourceName: "noImage")
    var profilePicture = #imageLiteral(resourceName: "userPic")
    var commentQuantity = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = image
        userPic.image = profilePicture
        accountNameLabel.text = "Account Name"
        locationLabel.text = "Location"
        
        userPic.layer.borderWidth = 0.5
        userPic.layer.masksToBounds = false
        userPic.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        userPic.layer.cornerRadius = userPic.frame.height/2
        userPic.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet {
            scrollView.minimumZoomScale = 0.9
            scrollView.maximumZoomScale = 1.8
            scrollView.delegate = self
            scrollView.addSubview(photo)
        }
    }
    
    @IBOutlet weak var photoTableView: UITableView!{
        didSet {
//            photoTableView.minimumZoomScale = 0.95
//            photoTableView.maximumZoomScale = 1.8
            photoTableView.delegate = self
            photoTableView.dataSource = self
//            photoTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    @IBOutlet weak private var photo: UIImageView!
    
    @IBOutlet weak private var userPic: UIImageView!
    
    @IBOutlet weak private var accountNameLabel: UILabel!
    
    @IBOutlet weak private var locationLabel: UILabel!
    
    
    
    
    // MARK: - UIScrollViewDelegate
    
    
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//
////        return photoTableView.cellForRow(at: .init(row: 0, section: 0))
//        return photo
//    }
//
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        scrollView.setZoomScale(1.0, animated: true)
//        scrollView.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0)
//        scrollView.isHidden = true
//        print("Ending")
//    }
//
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        print("Beginning")
//        scrollView.isHidden = false
//        scrollView.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0.6470462329)
//    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = section != 2 ? 1 : commentQuantity
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let prototype: String
        
        switch indexPath.section {
        case 0:
             prototype = "photoCell"
        case 1:
             prototype = "likeCell"
        default:
             prototype = "commentCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath)
        if let cell = cell as? PhotoTableViewCell {
            cell.photo.image = image
        }
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
