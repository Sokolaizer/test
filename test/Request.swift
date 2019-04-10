
import Foundation
import Alamofire
import Locksmith

class Request {
    
    enum Constant {
        static let mediaUrl = "https://api.instagram.com/v1/users/self/media/recent/?access_token"
        static let userAccount = "CurrentAccount"
        static let token = "token"
        static func getCommentUrlString(id: String , token: String) -> String {
            return "https://api.instagram.com/v1/media/" + id + "/comments?access_token" + token
        }
    }
    
    static func getRecentComments(id: String, completion: @escaping ([Instagram.CommentsResponse.Comment]) -> ()) {
        let token = Locksmith.loadDataForUserAccount(userAccount: Constant.userAccount)![Constant.token] as! String
        AF.request(Constant.getCommentUrlString(id: id, token: token), method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                guard let responseData = response.data else {return}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let commentsResponse = try! decoder.decode(Instagram.CommentsResponse.self, from: responseData)
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
            case .success:
                guard let responseData = response.data else {return}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let mediaResponse = try! decoder.decode(Instagram.MediaResponse.self, from: responseData)
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
        Store.mediaResponse.removeAll()
        Store.thumbnailsData.removeAll()
        Store.photoData.removeAll()
        Store.userPicData = nil
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: Constant.userAccount)
        } catch {
            print(error)
        }
        let cookieStorage = HTTPCookieStorage.shared
        for cookie in cookieStorage.cookies! as [HTTPCookie]{
            cookieStorage.deleteCookie(cookie)
        }
    }
}
