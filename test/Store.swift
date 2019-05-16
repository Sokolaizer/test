
import Foundation
struct Store {
  static var mediaResponse: [Instagram.MediaResponse.Post] = []
  static var thumbnailsData: [Data] = []
  static var imagesData: [Data?] = []
  static var userPicData: Data?
  
  static func getImagesData(complition: @escaping (Data, Int)->()) {
    DispatchQueue.global(qos: .background).async {
      for index in mediaResponse.indices {
        guard mediaResponse.count > index else {return}
        guard let url = URL(string: mediaResponse[index].images.standardResolution.url) else {return}
        do {
          let data = try Data(contentsOf: url)
          guard imagesData.count > index else {return}
          imagesData[index] = data
          complition(data, index)
        } catch {
          print(error)
        }
      }
    }
  }
}
