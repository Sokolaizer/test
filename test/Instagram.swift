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
    
    struct MediaResponse: Codable {
        let data: [NewPost]
        
        struct NewPost: Codable {
            let id: String
            let user: Person
            var images: Images
            let createdTime: String
            let caption: Caption?
            let likes: Like
            let location: Location?
            
            struct Location: Codable {
                let name: String
            }
            
            struct Like: Codable {
                let count: Int
            }
            struct Caption: Codable {
                let text: String
            }
            
            struct Person: Codable {
                let id: String
                let fullName: String
                let profilePicture: String
            }
            struct Images: Codable {
                var thumbnail: Image
                let lowResolution: Image
                let standardResolution: Image
                
                

                struct Image: Codable {
                    let url: String
                }
            }
        }
    }
}
