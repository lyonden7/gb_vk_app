//
//  FriendCell.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 04.02.2022.
//

import UIKit
import Kingfisher

class FriendCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var friendFullNameLabel: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    
    // MARK: - Properties
    
    static let reuseId = "FriendCell"

    // MARK: - Config cell
    
    /// Конфигурирование ячейки друга
    func configureFriendCell(with friend: Friend) {
        friendFullNameLabel.text = friend.firstName + " " + friend.lastName
        
        let friendAvatarUrl = URL(string: friend.friendAvatarUrlString)
        avatarView.imageAvatarView.kf.setImage(with: friendAvatarUrl)
    }
}
