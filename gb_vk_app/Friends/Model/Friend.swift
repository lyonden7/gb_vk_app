//
//  User.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 04.02.2022.
//

import UIKit
import RealmSwift

class FriendResponse: Decodable {
    let response: FriendObject
}

class FriendObject: Decodable {
    let count: Int
    let items: [Friend]
}

class Friend: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var friendAvatarUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case friendAvatarUrlString = "photo_50"
    }
}



// TO DO :
// У пользователей есть фото – это тоже связанные записи.
// Сделать массив фото связанным с пользователем
// (в таблице с друзьями еще один столбец с массивом фото (как в примере в методичке с питомцами)
