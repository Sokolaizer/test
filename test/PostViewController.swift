//
//  ImageViewController.swift
//  test
//
//  Created by Валентина Маркова on 08/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class PostViewController: UIViewController , UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    var image = #imageLiteral(resourceName: "noImage")
    var profilePicture = #imageLiteral(resourceName: "userPic")
    var accountName = "Account Name"
    var location = "Location undefined"
    var likes = "0 Likes"
    var id = ""
    var date = ""
    
    let request = RequestData()
    var comments: [(userName: String, text: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        userPic.image = profilePicture
        accountNameLabel.text = accountName
        if location != "null"{
            locationLabel.text = location
        } else {
            locationLabel.text = "Location undefined"
        }
        
        
        userPic.layer.borderWidth = 0.5
        userPic.layer.masksToBounds = false
        userPic.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        userPic.layer.cornerRadius = userPic.frame.height/2
        userPic.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        request.getRecentComments(id: id, token: RequestData.token) { comments in
            self.comments = comments
            self.photoTableView.reloadSections(IndexSet(integer: IndexSet.Element(2)), with: UITableView.RowAnimation.fade)
        }
    }
    
    
    @IBOutlet weak var photoTableView: UITableView!{
        didSet {
            photoTableView.minimumZoomScale = 1.0
            photoTableView.maximumZoomScale = 1.8
            photoTableView.delegate = self
            photoTableView.dataSource = self
            photoTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    
    @IBOutlet weak private var userPic: UIImageView!
    
    @IBOutlet weak private var accountNameLabel: UILabel!
    
    @IBOutlet weak private var locationLabel: UILabel!
    
    @IBOutlet weak var fadeView: UIView! {
        didSet {
            fadeView.isHidden = true
        }
    }
    
    
    
    
    // MARK: - UIScrollViewDelegate
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return photoTableView.cellForRow(at: .init(row: 0, section: 0))
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(1.0, animated: true)
        fadeView.isHidden = true
        photoTableView.cellForRow(at: .init(row: 0, section: 1))?.isHidden = false
        for row in comments.indices {
            photoTableView.cellForRow(at: IndexPath(row: row, section: 2))?.isHidden = false
        }
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
        fadeView.isHidden = false
        photoTableView.cellForRow(at: .init(row: 0, section: 1))?.isHidden = true
        for row in comments.indices {
        photoTableView.cellForRow(at: IndexPath(row: row, section: 2))?.isHidden = true
        }
        fadeView.backgroundColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8218107877)
        
        scrollView.clipsToBounds = false
        
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = section != 2 ? 1 : comments.count
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
        } else if let cell = cell as? LikeTableViewCell {
            cell.likeCountLabel.text = likes
            cell.createdTime.text = RequestData.convertDate(from: date)
        } else if let cell = cell as? CommentTableViewCell {
            
            let attributedUserString = NSMutableAttributedString(string:( comments[indexPath.row].userName + "  "), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)])
            let attributedCommentString = NSMutableAttributedString(string: comments[indexPath.row].text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .light)])
            
            attributedUserString.append(attributedCommentString)
            cell.commentLabel.attributedText = attributedUserString

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
