//
//  PhotoTableViewCell.swift
//  test
//
//  Created by Валентина Маркова on 13/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photo.image = #imageLiteral(resourceName: "noImage")
    }

    @IBOutlet weak var photo: UIImageView!
//        {
//        didSet {
//            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch(recognizer:)) )
//
//            photo.addGestureRecognizer(pinchGestureRecognizer)
//        }
//        
//
//    }
    
    @objc func pinch(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            fallthrough
        case .changed:
            recognizer.view?.transform = ((recognizer.view?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))!)
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
