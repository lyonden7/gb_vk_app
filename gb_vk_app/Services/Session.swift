//
//  Session.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 08.04.2022.
//

import UIKit

/// Синглтон для хранения данных о текущей сессии
class Session {
    
    static let instance = Session()
    
    private init() {}
    
    /// Свойство для хранения токена в VK
    var accessToken = String()
    /// Свойство для хранения идентификатора пользователя VK
    var userID = Int()
}
