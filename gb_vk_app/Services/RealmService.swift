//
//  RealmService.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 27.05.2022.
//

import Foundation
import RealmSwift

/// Методы для сохранения данных в Realm
class RealmService {
    
    /// Сохранение списка друзей в Realm
    func saveFriendsData(_ friends: [Friend]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
//            let realm = try Realm()
//            print(realm.configuration.fileURL)
            /// Старые данные о друзьях (для последующего удаления из базы)
            let oldFriends = realm.objects(Friend.self)
            realm.beginWrite()
            realm.delete(oldFriends)
            realm.add(friends)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    /// Сохранение фотографий пользователя/друзей в Realm
    func saveFriendPhotosData(_ photos: [Photo], ownerId: Int) {
        do {
            let realm = try Realm()
            let filter = "ownerId == " + String(ownerId)
            /// старые данные о фотографиях пользователя/друга (для последующего удаления из базы)
            let oldPhotos = realm.objects(Photo.self).filter(filter)
            realm.beginWrite()
            realm.delete(oldPhotos)
            realm.add(photos)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    /// Сохранение групп текущего пользователя в Realm
    func saveGroupsData(_ groups: [Group]) {
        do {
            let realm = try Realm()
            /// Старые данные о группах (для последующего удаления из базы)
            let oldGroups = realm.objects(Group.self)
            realm.beginWrite()
            realm.delete(oldGroups)
            realm.add(groups)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
}
