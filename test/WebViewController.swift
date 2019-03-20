//
//  WebViewController.swift
//  test
//
//  Created by Валентина Маркова on 14/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    enum Constants {
        static let halloLabelText = "Hallo!"
        static let labelLeftInset: CGFloat = 16
    }
    
    var token = ""
    
    // TODO: - Request repeating
    
    var requestMedia = RequestData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://api.instagram.com/oauth/authorize/?client_id=fae335ebae924fc5aa5855df05ee457d&redirect_uri=http://localhost&response_type=token")
        let request = URLRequest(url: url!)
        web.navigationDelegate = self
        web.load(request)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let currentURL = navigationAction.request.url ?? URL(string: "errorURL")
        decisionHandler(.allow)
        if ((currentURL?.absoluteString.hasPrefix("https://www.instagram.com/accounts/login/?force_authentication="))!) {
            web.isHidden = false
        }
        if (currentURL?.absoluteString.hasPrefix("http://localhost/#access_token="))! {
            if let urlString = currentURL?.absoluteString {
                web.isHidden = true
                activityIndicator.isHidden = false
                halloLabel.text = Constants.halloLabelText
                
                let separatorIndex = urlString.firstIndex(of: "=") ?? urlString.endIndex
                token = String(urlString[separatorIndex...])
                token.remove(at: token.startIndex)
            
                    requestMedia.getRecentMedia (token: token, completion: { mediaResponse in
                        RequestData.mediaResponse = mediaResponse

                        for index in mediaResponse.indices {
                            if let url = URL(string: mediaResponse[index].images.thumbnail.url)  {
                                if let data = try? Data(contentsOf: url) {
                                    RequestData.imagesData.append(data)
                                }
                            }
                        }
                        
                        
//                        RequestData.savedData = recievedData
//                        for index in RequestData.savedData.indices {
//                            RequestData.savedData[index].imageData = try? Data(contentsOf: (RequestData.savedData[index].imageURL!))
//                            if let imageData = RequestData.savedData[index].imageData {
//                                RequestData.imagesData.append(imageData)
//                            }
//                        }
                        RequestData.token = self.token
//                        RequestData.isPostsLoaded = true
                        self.performSegue(withIdentifier: "WebSegue", sender: self)
                    })
            }
        } else if currentURL == URL(string: "errorURL") {
            print("error")
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
        }
    }
    
    @IBOutlet weak var web: WKWebView!
    
    @IBOutlet weak var halloLabel: UILabel!
//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier {
//            if identifier == "WebSegue" {
//                let destinaton = segue.destination as? UITabBarController
//                if let finalyDestination = destinaton?.viewControllers?[0] as? CollectionViewController {
//                finalyDestination.collectionView.reloadData()
//                }
//            }
//        }
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }


}
