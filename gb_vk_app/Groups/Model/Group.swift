//
//  Group.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 04.02.2022.
//

import UIKit
import RealmSwift

class GroupResponse: Decodable {
    let response: GroupObject
}

class GroupObject: Decodable {
    let items: [Group]
}

class Group: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var groupsAvatarUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case groupsAvatarUrlString = "photo_50"
    }
}
