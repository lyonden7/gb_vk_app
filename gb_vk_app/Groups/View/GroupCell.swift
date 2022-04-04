//
//  GroupCell.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 04.02.2022.
//

import UIKit

class GroupCell: UITableViewCell {
    
    static let reuseId = "GroupCell"
    
    @IBOutlet weak var groupAvatarView: UIImageView! {
        didSet {
            self.groupAvatarView.layer.borderColor = UIColor.black.cgColor
            self.groupAvatarView.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var groupNameLabel: UILabel!

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        groupAvatarView.clipsToBounds = true
        groupAvatarView.layer.cornerRadius = groupAvatarView.frame.width / 2
    }
}
