
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct JSONContainer: Codable {
    let data: [Datum]
    
    init() {
        data = []
    }
}

struct Datum: Codable {
    let images: Images
    let type: TypeEnum
    let carouselMedia: [CarouselMedia]?
    
    enum CodingKeys: String, CodingKey {
        case images
        case type
        case carouselMedia = "carousel_media"
    }
}

struct CarouselMedia: Codable {
    let images: Images
    
    enum CodingKeys: String, CodingKey {
        case images
    }
}

struct Images: Codable {
    let thumbnail, lowResolution, standardResolution: ImageParameters
    
    enum CodingKeys: String, CodingKey {
        case thumbnail
        case lowResolution = "low_resolution"
        case standardResolution = "standard_resolution"
    }
}

struct ImageParameters: Codable {
    let width, height: Int
    let url: String
}

enum TypeEnum: String, Codable {
    case carousel = "carousel"
    case image = "image"
}




// MARK: Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
