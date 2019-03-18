//
//  Instagram.swift
//  test
//
//  Created by Роман Козлов on 18.03.2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import Foundation

enum Instagram {
    
    struct CommentsResponse: Codable {
        let data: [Comment]
        
        struct Comment: Codable {
            let createdTime: String
            let text: String
            let from: Person
            
            struct Person: Codable {
                let username: String
            }
        }
    }
    
}
