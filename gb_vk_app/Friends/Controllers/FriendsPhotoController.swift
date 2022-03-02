//
//  FriendsPhotoController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 03.02.2022.
//

import UIKit

class FriendsPhotoController: UICollectionViewController {

    var photos = [UIImage]()
    var friend: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(friend != nil)
        title = "\(friend.firstName) \(friend.lastName)"
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendPhotoCell", for: indexPath) as! FriendPhotoCell
    
        cell.photoView.image = photos[indexPath.item]
        
        let likeCount = Int.random(in: 5...500)
        let isLiked = Bool.random()
        cell.configureLikeControl(likes: likeCount, isLikedByUser: isLiked)
    
        return cell
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
