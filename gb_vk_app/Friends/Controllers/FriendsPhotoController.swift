//
//  FriendsPhotoController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit
import RealmSwift

/// Контроллер для отображения фотографий выбранного друга
class FriendsPhotoController: UICollectionViewController {

    let networkService = NetworkService(token: Session.instance.accessToken)
    
    var photos = [Photo]()
    var friend: Friend!
    var ownerId = Int()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(friend != nil)
        title = "\(friend.firstName) \(friend.lastName)"
        
        // как только загружается экран - загружаем данные из Realm
        loadFriendPhotosDataFromRealm(ownerId: ownerId)
        
        // далее делаем запрос на бэк и загружаем новые актуальные данные из Realm
        networkService.loadFriendPhoto(ownerId: ownerId) { [weak self] in
            self?.loadFriendPhotosDataFromRealm(ownerId: self!.ownerId)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendPhotoCell.reuseId, for: indexPath) as! FriendPhotoCell
    
        cell.configureFriendPhotoCell(with: photos[indexPath.item])
        
        let likeCount = Int.random(in: 5...500)
        let isLiked = Bool.random()
        cell.configureLikeControl(likes: likeCount, isLikedByUser: isLiked)
    
        return cell
    }
    
    // MARK: - Functions
    
    ///  Получение фотографий пользователя/друзей из Realm
    func loadFriendPhotosDataFromRealm(ownerId: Int) {
        do {
            let realm = try Realm()
            let filter = "ownerId == " + String(ownerId)
            let photos = realm.objects(Photo.self).filter(filter)
            self.photos = Array(photos)
            self.collectionView.reloadData()
        } catch {
            print(error)
        }
    }
}

extension FriendsPhotoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width / 3).rounded(.down)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension FriendsPhotoController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Big Photo",
           let selectedPhotoIndexPath = collectionView.indexPathsForSelectedItems?.first,
           let bigPhotoVC = segue.destination as? PhotoViewController {
            bigPhotoVC.photos = photos
            bigPhotoVC.selectedPhotoIndex = selectedPhotoIndexPath.item
            collectionView.deselectItem(at: selectedPhotoIndexPath, animated: true)
        }
    }
}
