//
//  AvatarView.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 20.02.2022.
//

import UIKit

/// Класс для создания аватара друзей - содержит фото друга и view с тенью
class AvatarView: UIView {

    // MARK: - Outlets
    
    @IBOutlet weak var imageAvatarView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    // MARK: - Properties

    @IBInspectable var shadowColor: UIColor = .black { didSet { setNeedsDisplay() } }
    @IBInspectable var shadowRadius: CGFloat = 8 { didSet { setNeedsDisplay() } }
    @IBInspectable var shadowOpacity: Float = 1 { didSet { setNeedsDisplay() } }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        shadowView.clipsToBounds = false  -  вызывается для UIView
        shadowView.layer.masksToBounds = false   // вызывается для слоя
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.shadowOffset = CGSize.zero
        
//        userAvatarView.clipsToBounds = true
        imageAvatarView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowView.layer.cornerRadius = bounds.width/2
        imageAvatarView.layer.cornerRadius = bounds.width/2
    }
}
