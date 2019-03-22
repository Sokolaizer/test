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
import Locksmith

struct Request {
    
    enum Constant {
        static let mediaUrl = "https://api.instagram.com/v1/users/self/media/recent/?access_token"
        static let userAccount = "CurrentAccount"
        static let token = "token"
        
        static func getCommentUrlString(id: String , token: String) -> String {
            return "https://api.instagram.com/v1/media/" + id + "/comments?access_token" + token
        }
    }
    
    static var mediaResponse: [Instagram.MediaResponse.Post] = []
    static var thumbnailsData: [Data] = []
    static var photoData: [Data] = []
    static let profilePictureData = try? Data(contentsOf: URL(string: mediaResponse[0].user.profilePicture)!)
    
    
    
    static func getRecentComments(id: String, completion: @escaping ([Instagram.CommentsResponse.Comment]) -> ()) {
        let token = Locksmith.loadDataForUserAccount(userAccount: Constant.userAccount)![Constant.token] as! String
        AF.request(Constant.getCommentUrlString(id: id, token: token), method: .get).validate().responseJSON { response in
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
    
    static func getRecentMedia(completion: @escaping ([Instagram.MediaResponse.Post]) -> ()) {
        let token = Locksmith.loadDataForUserAccount(userAccount: Constant.userAccount)![Constant.token] as! String
        let urlString = Constant.mediaUrl + token
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
    
    static func logOut() {
        let cookieJar : HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! as [HTTPCookie]{
            cookieJar.deleteCookie(cookie)
        }
        Request.mediaResponse = []
        Request.thumbnailsData = []
        Request.photoData = []
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: Constant.userAccount)
        } catch {
            print("Unable to delete token")
        }
    }
    
    static func fetchImage( from data:Data?, or defaultImage: UIImage) -> UIImage {
        if let data = data {
            return UIImage(data: data) ?? defaultImage
        } else {
            print("URL doesn't contents correct data")
            return defaultImage
        }
    }
}
