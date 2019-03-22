//
//  LikePhotoTableViewCell.swift
//  test
//
//  Created by Валентина Маркова on 13/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel! {
        didSet {
            likeCountLabel.text = "0 Likes"
        }
    }
}
