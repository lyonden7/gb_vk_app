//
//  Photo.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 18.05.2022.
//

import UIKit

class PhotoResponse: Decodable {
    let response: PhotoObject
}

class PhotoObject: Decodable {
    let items: [Photo]
}

class Photo: Decodable {
    var photoUrlString = ""
    var sizeType = ""
    
    enum CodingKeys: String, CodingKey {
        case sizes
    }
    
    enum SizesKeys: String, CodingKey {
        case photoUrlString = "url"
        case sizeType = "type"
    }
    
    required init(from decoder: Decoder) throws {
        let photoContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        var sizesContainer = try photoContainer.nestedUnkeyedContainer(forKey: .sizes)
        
        while !sizesContainer.isAtEnd {
            let sizesValues = try sizesContainer.nestedContainer(keyedBy: SizesKeys.self)
            let sizeType = try sizesValues.decode(String.self, forKey: .sizeType)
            switch sizeType {
            case "x":
                self.photoUrlString = try sizesValues.decode(String.self, forKey: .photoUrlString)
            case "m":
                self.photoUrlString = try sizesValues.decode(String.self, forKey: .photoUrlString)
            default:
                break
            }
        }
    }
}
