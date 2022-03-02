//
//  FriendPhotoCell.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 04.02.2022.
//

import UIKit

class FriendPhotoCell: UICollectionViewCell {

    @IBOutlet var photoView: UIImageView!
    @IBOutlet var likeControl: LikeControl!

    // MARK: - Public
    
    public func configureLikeControl(likes count: Int, isLikedByUser: Bool) {
        likeControl.configure(likes: count, isLikedByUser: isLikedByUser)
    }
}
