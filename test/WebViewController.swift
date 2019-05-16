
import UIKit
import WebKit
import Locksmith

class WebViewController: UIViewController {
  enum Constants {
    static let backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.09411764706, blue: 0.3019607843, alpha: 1)
  }
  let preferences = Preferences.get()!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    view.backgroundColor = Constants.backgroundColor
    if Locksmith.loadDataForUserAccount(userAccount: preferences.userAccount) != nil {
      Navigation.toCollectionViewController(from: self)
    } else {
      var url = preferences.authorizeURL
      if isNeedAuthentication {
        url = preferences.forceAuthentication
        isNeedAuthentication = false
      }
      let request = URLRequest(url: URL(string: url)!)
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
    if ((currentURL.absoluteString.hasPrefix(preferences.authenticationPrefix))) {
      view.backgroundColor = .darkGray
      web.isHidden = false
    }
    if (currentURL.absoluteString.hasPrefix(preferences.tokenPrefix)) {
      let urlString = currentURL.absoluteString
      view.backgroundColor = Constants.backgroundColor
      let separatorIndex = urlString.firstIndex(of: "=") ?? urlString.endIndex
      do {
        try Locksmith.saveData(data: [preferences.token : String(urlString[separatorIndex...])], forUserAccount: preferences.userAccount)
      } catch {
        print(error)
      }
      Navigation.toCollectionViewController(from: self)
    }
  }
}
