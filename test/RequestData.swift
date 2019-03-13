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
    
    
    
    let urlString = "https://api.instagram.com/v1/users/self/media/recent/?access_token=211784561.fae335e.43f88dfed2734374a9083235bbafd490"
    
    
    
    
    
    func getData(completion: @escaping ([Post]) -> ()) {
        var recivedData: [Post] = []
        AF.request(urlString, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for item in json["data"] {
                    let id = item.1["id"].rawString()
                    let likes = item.1["likes"]["count"].rawString()
                    let accountName = item.1["user"]["full_name"].rawString()
                    let location = item.1["location"]["name"].rawString()
                    let picture = item.1["images"]["standard_resolution"]["url"].rawString()
                    if let picture = picture, let id = id, let likes = likes, let accountName = accountName, let location = location {
                        let post = Post(imagePath: picture, idPath: id, likesPath: likes, accountNamePath: accountName, locationPath: location)
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
    static let temporaryImageList:[String] = [
       "https://scontent.cdninstagram.com/vp/3623a9c69036bf17ee5705dadbb9b9a0/5D29035E/t51.2885-15/sh0.08/e35/s640x640/47584251_365231284033688_6963532960829764110_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/7eb3cd90c95e1e78419e44cbb7ab6671/5D1674AA/t51.2885-15/sh0.08/e35/s640x640/20398611_1424162230982266_7070756036080041984_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/a518ef2d874384347d639a0c9679cf83/5D17B306/t51.2885-15/sh0.08/e35/s640x640/27881372_1823778531248159_6721190215521665024_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/32658b15019c499e6cf1b1b482a9a48a/5D28E851/t51.2885-15/sh0.08/e35/s640x640/30953967_1939415482797580_724376793162711040_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/584be0f9762564e0f226020a954a3d4f/5D1CFE1C/t51.2885-15/sh0.08/e35/s640x640/18160660_522795367844334_754317169096916992_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/3efeff613bbe4a71a78ebcb23246d49c/5D25196F/t51.2885-15/e15/1168688_253351451501178_841835479_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/bf33be7bd21e353e58ee5fdb6291ac27/5D2187C6/t51.2885-15/e15/11242524_1417617428559646_1221988976_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/2d872c815b64c719e8f9a3a9d7f3504f/5D23CDF7/t51.2885-15/sh0.08/e35/s640x640/27573705_2121544994740528_13721943769350144_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/44e946ba473fe41d239a5c7c86e85dee/5D1BEFB2/t51.2885-15/sh0.08/e35/s640x640/27878271_153930691980380_5761798026012131328_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/c90c32d33759e8f8e89e45ece4bae00d/5D09F72F/t51.2885-15/sh0.08/e35/s640x640/27574049_152658475448192_2544408243275300864_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/be5c10a96ebbc99e83ca5899c79cb24f/5D058B19/t51.2885-15/sh0.08/e35/s640x640/27576696_217508955472654_3347297060083728384_n.jpg?_nc_ht=scontent.cdninstagram.com",
       "https://scontent.cdninstagram.com/vp/191fa66276d06ab6acef64850dccebe4/5D206F5F/t51.2885-15/sh0.08/e35/s640x640/27579202_359576887786294_6428321502323539968_n.jpg?_nc_ht=scontent.cdninstagram.com"
    ]
    static let tmpImagesData = temporaryImageList.map({URL(string: $0)})
    
    static let tmpProfilePictureData = URL(string: temporaryProfilePicrurePath)
    
    static func fetchImage( from url:URL?, or defaultImage: UIImage) -> UIImage {
        if let url = url{
        let data = try? Data(contentsOf: url)
        if let data = data {
            return UIImage(data: data) ?? defaultImage
        } else {
            print("URL doesn't contents correct data")
            return defaultImage
        }
        } else {
            print("Incorrect URL")
            return defaultImage
        }
    }
    
    
    
    static let imageUrl = URL(string: "https://scontent.cdninstagram.com/vp/3623a9c69036bf17ee5705dadbb9b9a0/5D29035E/t51.2885-15/sh0.08/e35/s640x640/47584251_365231284033688_6963532960829764110_n.jpg?_nc_ht=scontent.cdninstagram.com")
}
