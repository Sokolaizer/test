//
//  ImageViewController.swift
//  test
//
//  Created by Валентина Маркова on 08/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image = #imageLiteral(resourceName: "noImage")
    var profilePicture = #imageLiteral(resourceName: "userPic")

    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = image
        userPic.image = profilePicture
        accountNameLabel.text = "Account Name"
        locationLabel.text = "Location"
        
        userPic.layer.borderWidth = 1
        userPic.layer.masksToBounds = false
        userPic.layer.borderColor = UIColor.white.cgColor
        userPic.layer.cornerRadius = userPic.frame.height/2
        userPic.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak private var photo: UIImageView!
    
    @IBOutlet weak private var userPic: UIImageView!
    
    @IBOutlet weak private var accountNameLabel: UILabel!
    
    @IBOutlet weak private var locationLabel: UILabel!
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
