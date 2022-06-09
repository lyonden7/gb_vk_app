//
//  FriendPhotoCell.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 04.02.2022.
//

import UIKit
import Kingfisher

class FriendPhotoCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var likeControl: LikeControl!
    
    // MARK: - Properties
    
    static let reuseId = "FriendPhotoCell"
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.image = nil
    }

    // MARK: - Public function
    
    /// Конфигурирование LikeControl, количества лайков и состояния лайка текущего пользователя - на данный момент используются рандомные значения
    func configureLikeControl(likes count: Int, isLikedByUser: Bool) {
        likeControl.configure(likes: count, isLikedByUser: isLikedByUser)
    }
    
    // MARK: - Config cell
    
    /// Конфигурирование ячейки фото
    func configureFriendPhotoCell(with photo: Photo) {
        let friendPhotoUrl = URL(string: photo.photoUrlString)
        photoView.kf.setImage(with: friendPhotoUrl)
    }
}
