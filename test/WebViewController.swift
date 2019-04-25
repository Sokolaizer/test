
import UIKit
import WebKit
import Locksmith

class WebViewController: UIViewController {
  enum Constants {
    static let authorizeURL = URL(string:"https://api.instagram.com/oauth/authorize/?client_id=fae335ebae924fc5aa5855df05ee457d&redirect_uri=http://localhost&response_type=token&hl=en")!
    static let forceAuthentication = URL(string: "https://www.instagram.com/accounts/login/?force_authentication=1&only_user_pwd_authentication=1&platform_app_id=&next=/oauth/authorize/%3Fclient_id%3Dfae335ebae924fc5aa5855df05ee457d%26redirect_uri%3Dhttp%3A//localhost%26response_type%3Dtoken")!
    static let authenticationPrefix = "https://www.instagram.com/accounts/login/?force_authentication="
    static let tokenPrefix = "http://localhost/#access_token="
    static let userAccount = "CurrentAccount"
    static let token = "token"
    static let backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.09411764706, blue: 0.3019607843, alpha: 1)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    view.backgroundColor = Constants.backgroundColor
    if Locksmith.loadDataForUserAccount(userAccount: Constants.userAccount) != nil {
      Navigation.toCollectionViewController(from: self)
    } else {
      var url = Constants.authorizeURL
      if isNeedAuthentication {
        url = Constants.forceAuthentication
        isNeedAuthentication = false
      }
      let request = URLRequest(url: url)
      web.navigationDelegate = self
      web.load(request)
    }
  }
  
  var isNeedAuthentication = false
  @IBOutlet weak var web: WKWebView!
  @IBOutlet weak var errorLabel: UILabel!
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard let currentURL = navigationAction.request.url else {return}
    decisionHandler(.allow)
    if ((currentURL.absoluteString.hasPrefix(Constants.authenticationPrefix))) {
      view.backgroundColor = .darkGray
      web.isHidden = false
    }
    if (currentURL.absoluteString.hasPrefix(Constants.tokenPrefix)) {
      let urlString = currentURL.absoluteString
      view.backgroundColor = Constants.backgroundColor
      let separatorIndex = urlString.firstIndex(of: "=") ?? urlString.endIndex
      do {
        try Locksmith.saveData(data: [Constants.token : String(urlString[separatorIndex...])], forUserAccount: Constants.userAccount)
      } catch {
        print(error)
      }
      Navigation.toCollectionViewController(from: self)
    }
  }
}
