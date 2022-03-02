//
//  LikeControl.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 28.02.2022.
//

import UIKit

class LikeControl: UIControl {
    
    var count: Int = 0

    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var likeImageView: UIImageView!
    
    public var isLiked: Bool = false {
        didSet {
            if !isLiked {
                likeImageView.image = UIImage(systemName: "heart.fill")
                likeImageView.tintColor = .red
                likeCountLabel.textColor = .red
                setupGestureRecognizer()
                count += 1
                likeCountLabel.text = String(count)
            } else {
                likeImageView.image = UIImage(systemName: "heart")
                likeImageView.tintColor = .black
                likeCountLabel.textColor = .black
                setupGestureRecognizer()
                count -= 1
                likeCountLabel.text = String(count)
            }
        }
    }
    
    // MARK: - Private
    
    private func setupGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.numberOfTouchesRequired = 1
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(tap)
    }
    
    @objc private func tapped(_ tapGesture: UITapGestureRecognizer) {
        isLiked.toggle()
        setNeedsDisplay()
        sendActions(for: .valueChanged)
    }
    
    // MARK: - Public
    
    public func configure(likes count: Int, isLikedByUser: Bool) {
        self.count = count
        self.isLiked = isLikedByUser
    }
}
