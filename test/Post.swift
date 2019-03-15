//
//  File.swift
//  test
//
//  Created by Валентина Маркова on 13/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import Foundation

struct Post {
    
    let thumbnailString: String
    let id: String
    let likes: String
    let accountName: String
    let location: String
    let photoString: String
    
    var imageData: Data?
    
    var imageURL: URL? {
        return URL(string: thumbnailString)
    }
}
