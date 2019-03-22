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
        photo.image = #imageLiteral(resourceName: "noImage")
    }
    
    @IBOutlet weak var photo: UIImageView!
}
