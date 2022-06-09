//
//  NetworkService.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 15.04.2022.
//

import Foundation
import Alamofire

/// Запросы к VK API
class NetworkService {
    
    // MARK: - Properties
    
    static let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
    
    let realmService = RealmService()
    
    let baseURL = "https://api.vk.com/method/"
    let versionAPI = "5.131"
    private let token: String
    
    init(token: String) {
        self.token = token
    }
    
    // MARK: - Functions
    
    /// Получение списка друзей от VK API с последующим сохранением в Realm
    func loadFriends(completion: @escaping () -> Void) {
        let path = "friends.get"
        let url = baseURL + path
        let parameters: Parameters = [
            "access_token": token,
            "v": versionAPI,
            "fields": "photo_50",
            "order": "hints"
        ]
        
        NetworkService.session.request(url, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let friend = try! JSONDecoder().decode(FriendResponse.self, from: data).response.items
            self.realmService.saveFriendsData(friend)
            completion()
        }
    }
    
    /// Получение фотографий пользователя/друга от VK API с последующим сохранением в Realm
    func loadFriendPhoto(ownerId: Int, completion: @escaping () -> Void) {
        let path = "photos.getAll"
        let url = baseURL + path
        let parameters: Parameters = [
            "access_token": token,
            "v": versionAPI,
            "extended": 1,
            "owner_id": ownerId,
            "count": 200
        ]
        
        NetworkService.session.request(url, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let photo = try! JSONDecoder().decode(PhotoResponse.self, from: data).response.items
            self.realmService.saveFriendPhotosData(photo, ownerId: ownerId)
            completion()
        }
    }
    
    /// Получение групп текущего пользователя от VK API с последующим сохранением в Realm
    func loadGroups(completion: @escaping () -> Void) {
        let path = "groups.get"
        let url = baseURL + path
        let parameters: Parameters = [
            "access_token": token,
            "v": versionAPI,
            "extended": 1
        ]
        
        NetworkService.session.request(url, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let group = try! JSONDecoder().decode(GroupResponse.self, from: data).response.items
            self.realmService.saveGroupsData(group)
            completion()
        }
    }
    
    /// Получение групп по поисковому запросу от VK API
    func loadSearchGroups(for searchText: String, completion: @escaping ([Group]) -> Void) {
        let path = "groups.search"
        let url = baseURL + path
        let parameters: Parameters = [
            "access_token": token,
            "v": versionAPI,
            "q": searchText
        ]
        
        NetworkService.session.request(url, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let group = try! JSONDecoder().decode(GroupResponse.self, from: data).response
            completion(group.items)
        }
    }
}
