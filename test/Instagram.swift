
import Foundation

enum Instagram {
  
  struct CommentsResponse: Codable {
    let data: [Comment]
    
    struct Comment: Codable {
      var text: String
      var from: Person
      
      struct Person: Codable {
        var username: String
      }
    }
  }
  
  struct MediaResponse: Codable {
    let data: [Post]
    
    struct Post: Codable {
      let id: String
      let user: Person
      var images: Images
      let createdTime: String
      let caption: Caption?
      let likes: Like
      let location: Location?
      
      struct Location: Codable {
        let name: String
      }
      
      struct Like: Codable {
        let count: Int
      }
      struct Caption: Codable {
        let text: String
      }
      
      struct Person: Codable {
        let id: String
        let fullName: String
        let username: String
        let profilePicture: String
      }
      struct Images: Codable {
        var thumbnail: Image
        let lowResolution: Image
        let standardResolution: Image
        
        
        
        struct Image: Codable {
          let url: String
        }
      }
    }
  }
}
