
import UIKit
import WebKit
import Locksmith

class WebViewController: UIViewController, WKNavigationDelegate {
    enum Constants {
        static let helloLabelText = "Hello!"
        static let authorizeURL = "https://api.instagram.com/oauth/authorize/?client_id=fae335ebae924fc5aa5855df05ee457d&redirect_uri=http://localhost&response_type=token"
        static let errorDescription = "Could not connect to the server."
        static let authenticationPrefix = "https://www.instagram.com/accounts/login/?force_authentication="
        static let tokenPrefix = "http://localhost/#access_token="
        static let forceAuthentication = "https://www.instagram.com/accounts/login/?force_authentication=1&only_user_pwd_authentication=1&platform_app_id=&next=/oauth/authorize/%3Fclient_id%3Dfae335ebae924fc5aa5855df05ee457d%26redirect_uri%3Dhttp%3A//localhost%26response_type%3Dtoken"
        static let webSegueIdentifier = "WebSegue"
    }
    
    var isNeedAuthentication = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        let url: URL?
        if isNeedAuthentication {
            url = URL(string: Constants.forceAuthentication)
            isNeedAuthentication = false
        } else {
            url = URL(string: Constants.authorizeURL)
        }
        let request = URLRequest(url: url!)
        web.navigationDelegate = self
        web.load(request)
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
        }
    }
    @IBOutlet weak var web: WKWebView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - WK Navigation Delegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if error.localizedDescription != Constants.errorDescription {
            errorLabel.isHidden = false
            errorLabel.text = error.localizedDescription
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let currentURL = navigationAction.request.url else {return}
        decisionHandler(.allow)
        if ((currentURL.absoluteString.hasPrefix(Constants.authenticationPrefix))) {
            web.isHidden = false
        }
        if (currentURL.absoluteString.hasPrefix(Constants.tokenPrefix)) {
            let urlString = currentURL.absoluteString
            web.isHidden = true
            activityIndicator.isHidden = false
            helloLabel.text = Constants.helloLabelText
            let separatorIndex = urlString.firstIndex(of: "=") ?? urlString.endIndex
            do {
                try Locksmith.saveData(data: ["token" : String(urlString[separatorIndex...])], forUserAccount: "CurrentAccount")
            } catch {
                print(error)
            }
            
            Request.getRecentMedia (completion: { mediaResponse in
                Store.mediaResponse = mediaResponse
                for index in mediaResponse.indices {
                    guard let url = URL(string: mediaResponse[index].images.thumbnail.url),
                        let userPicURL = URL(string: mediaResponse[0].user.profilePicture) else {return}
                    guard let data = try? Data(contentsOf: url),
                        let userPicData = try? Data(contentsOf: userPicURL) else {return}
                    Store.thumbnailsData.append(data)
                    Store.userPicData = userPicData
                    Store.photoData.append(nil)
                }
                self.performSegue(withIdentifier: Constants.webSegueIdentifier, sender: self)
            })
        }
    }
}
