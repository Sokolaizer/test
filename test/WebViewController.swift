//
//  WebViewController.swift
//  test
//
//  Created by Валентина Маркова on 14/03/2019.
//  Copyright © 2019 Роман Козлов. All rights reserved.
//

import UIKit
import WebKit
import Locksmith

class WebViewController: UIViewController, WKNavigationDelegate {
    enum Constants {
        static let helloLabelText = "Hello!"
        static let authorizeURL = "https://api.instagram.com/oauth/authorize/?client_id=fae335ebae924fc5aa5855df05ee457d&redirect_uri=http://localhost&response_type=token"
        static let authenticationPrefix = "https://www.instagram.com/accounts/login/?force_authentication="
        static let tokenPrefix = "http://localhost/#access_token="
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: Constants.authorizeURL)
        let request = URLRequest(url: url!)
        web.navigationDelegate = self
        web.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let currentURL = navigationAction.request.url ?? URL(string: "errorURL")
        decisionHandler(.allow)
        if ((currentURL?.absoluteString.hasPrefix(Constants.authenticationPrefix))!) {
            web.isHidden = false
        }
        if (currentURL?.absoluteString.hasPrefix(Constants.tokenPrefix))! {
            if let urlString = currentURL?.absoluteString {
                web.isHidden = true
                activityIndicator.isHidden = false
                helloLabel.text = Constants.helloLabelText
                let separatorIndex = urlString.firstIndex(of: "=") ?? urlString.endIndex
                do {
                try Locksmith.saveData(data: ["token" : String(urlString[separatorIndex...])], forUserAccount: "CurrentAccount")
                } catch {
                    print("Unable to save data")
                }
            
                Request.getRecentMedia (completion: { mediaResponse in
                        Request.mediaResponse = mediaResponse

                        for index in mediaResponse.indices {
                            if let url = URL(string: mediaResponse[index].images.thumbnail.url)  {
                                if let data = try? Data(contentsOf: url) {
                                    Request.thumbnailsData.append(data)
                                }
                            }
                        }
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
    @IBOutlet weak var helloLabel: UILabel!
}
