//
//  Url.swift
//  test
//
//  Created by Валентина Маркова on 03/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct RequestData {
    
    static var imagesData: [Data] = []
    static var token = ""
    
    let mediaUrlString = "https://api.instagram.com/v1/users/self/media/recent/?access_token="
    
    
    static var savedData:[Post] = []
    static var isPostsLoaded = false
    
    func getCommentUrlString(id: String , token: String) -> String {
        return "https://api.instagram.com/v1/media/" + id + "/comments?access_token=" + token
    }
    
    func getRecentComments(id: String,token: String, completion: @escaping ([(userName: String, text: String)]) -> ()) {
        var recievedData: [(userName: String, text: String)] = []
        AF.request(getCommentUrlString(id: id, token: token), method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for item in json["data"] {
                    let user = item.1["from"]["username"].rawString()
                    let text = item.1["text"].rawString()
                    if let user = user, let text = text {
                        recievedData.append((userName: user, text: text))
                    }
                }
                completion(recievedData)
                
            case .failure(let error):
                print(error)
            }
            }
    }
    
    
    
    func getRecentMedia(token: String, completion: @escaping ([Post]) -> ()) {
        var recivedData: [Post] = []
        let urlString = mediaUrlString + token
        AF.request(urlString, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for item in json["data"] {
                    let id = item.1["id"].rawString()
                    let likes = item.1["likes"]["count"].rawString()
                    let accountName = item.1["user"]["full_name"].rawString()
                    let location = item.1["location"]["name"].rawString()
                    let thumbnail = item.1["images"]["thumbnail"]["url"].rawString()
                    let photo = item.1["images"]["standard_resolution"]["url"].rawString()
                    if let thumbnail = thumbnail, let id = id, let likes = likes, let accountName = accountName, let location = location, let photo = photo {
                        let post = Post(thumbnailString: thumbnail, id: id, likes: likes, accountName: accountName, location: location, photoString: photo, imageData: nil)
                        recivedData.append(post)
                    }
                }
                completion(recivedData)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    

    
    static let temporaryProfilePicrurePath = "https://scontent.cdninstagram.com/vp/9bf57db2f802d9fa104eb639f9af86a5/5D23B5F7/t51.2885-19/11420423_1711958612365610_147992485_a.jpg?_nc_ht=scontent.cdninstagram.com"
    
    static let tmpProfilePictureData = try? Data(contentsOf: URL(string: temporaryProfilePicrurePath)!)
    
    
    static func fetchImage( from data:Data?, or defaultImage: UIImage) -> UIImage {
        if let data = data {
            return UIImage(data: data) ?? defaultImage
        } else {
            print("URL doesn't contents correct data")
            return defaultImage
        }
    }
}
