//
//  Photo.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 18.05.2022.
//

import UIKit
import RealmSwift

class PhotoResponse: Decodable {
    let response: PhotoObject
}

class PhotoObject: Decodable {
    let items: [Photo]
}

class Photo: Object, Decodable {
    @Persisted var id: Int
    @Persisted var ownerId: Int
    @Persisted var photoUrlString: String
    @Persisted var sizeType: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sizes
    }
    
    enum SizesKeys: String, CodingKey {
        case photoUrlString = "url"
        case sizeType = "type"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let photoContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try photoContainer.decode(Int.self, forKey: .id)
        self.ownerId = try photoContainer.decode(Int.self, forKey: .ownerId)

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
