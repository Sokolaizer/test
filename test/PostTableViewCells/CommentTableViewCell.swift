//
//  CommentTableViewCell.swift
//  test
//
//  Created by Валентина Маркова on 13/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    var userName = "userName"
    var comment = "Comment"
//    let attrs = [NSAttributedString: UIFont.boldSystemFont(ofSize: 14)]

  
    
    

    @IBOutlet weak var commentLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
