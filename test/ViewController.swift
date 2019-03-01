//
//  ViewController.swift
//  test
//
//  Created by Роман Козлов on 27.02.2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=211784561.fae335e.43f88dfed2734374a9083235bbafd490"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for post in json["data"] {
                    print(post)
                    print("__________________________________")
                }
//                print("JSON: \(json["data"])")
            case .failure(let error):
                print(error)
            }
        }
    }


}

