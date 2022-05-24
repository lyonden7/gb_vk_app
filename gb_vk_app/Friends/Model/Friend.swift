//
//  User.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 04.02.2022.
//

import UIKit

class FriendResponse: Decodable {
    let response: FriendObject
}

class FriendObject: Decodable {
    let count: Int
    let items: [Friend]
}

class Friend: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let friendAvatarUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case friendAvatarUrlString = "photo_50"
    }
}
