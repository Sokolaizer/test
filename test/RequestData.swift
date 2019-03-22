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
    
    static var mediaResponse: [Instagram.MediaResponse.NewPost] = []

    static var imagesData: [Data] = []
    static var photoData: [Data] = []
    static var token = ""
    
    let mediaUrlString = "https://api.instagram.com/v1/users/self/media/recent/?access_token"

    func getCommentUrlString(id: String , token: String) -> String {
        return "https://api.instagram.com/v1/media/" + id + "/comments?access_token" + token
    }

    func getRecentComments(id: String, token: String, completion: @escaping ([Instagram.CommentsResponse.Comment]) -> ()) {
        AF.request(getCommentUrlString(id: id, token: token), method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = try! JSON(value).rawData()
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let commentsResponse = try! decoder.decode(Instagram.CommentsResponse.self, from: jsonData)
                completion(commentsResponse.data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getRecentMedia(token: String, completion: @escaping ([Instagram.MediaResponse.NewPost]) -> ()) {
        let urlString = mediaUrlString + token
        AF.request(urlString, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let jsonData = try! json.rawData()
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let mediaResponse = try! decoder.decode(Instagram.MediaResponse.self, from: jsonData)
                completion(mediaResponse.data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func convertDate(from string: String) -> String {
        let int = Int(string) ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(int))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
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

