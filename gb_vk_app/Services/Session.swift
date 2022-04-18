//
//  Session.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 08.04.2022.
//

import UIKit

class Session {
    
    static let instance = Session()
    
    private init() {}
    
    var accessToken = String()
    var userID = Int()
}
