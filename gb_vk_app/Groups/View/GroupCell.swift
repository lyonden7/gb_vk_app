//
//  GroupCell.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 04.02.2022.
//

import UIKit
import Kingfisher

class GroupCell: UITableViewCell {
    
    static let reuseId = "GroupCell"
    
    @IBOutlet weak var groupAvatarView: UIImageView! {
        didSet {
            self.groupAvatarView.layer.borderColor = UIColor.black.cgColor
            self.groupAvatarView.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var groupNameLabel: UILabel!
    
    // MARK: - Lifecycle

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        groupAvatarView.clipsToBounds = true
        groupAvatarView.layer.cornerRadius = groupAvatarView.frame.width / 2
    }
    
    // MARK: - Config cell
    
    /// Конфигурирование ячейки группы
    func configureGroupCell(with group: Group) {
        groupNameLabel.text = group.name
        
        let groupAvatarUrl = URL(string: group.groupsAvatarUrlString)
        groupAvatarView.kf.setImage(with: groupAvatarUrl)
    }
}
