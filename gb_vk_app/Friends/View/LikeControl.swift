//
//  LikeControl.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 28.02.2022.
//

import UIKit

class LikeControl: UIControl {

    // MARK: - Outlets
    
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var likeImageView: UIImageView!
    
    // MARK: - Public properties
    
    public var isLiked: Bool = false {
        didSet {
            if !isLiked {
                likeImageView.image = UIImage(systemName: "heart.fill")
                likeImageView.tintColor = .red
                likeCountLabel.textColor = .red
                setupGestureRecognizer()
                count += 1
                animationFlipFromLeft(likeCountLabel, String(count))
            } else {
                likeImageView.image = UIImage(systemName: "heart")
                likeImageView.tintColor = .black
                likeCountLabel.textColor = .black
                setupGestureRecognizer()
                count -= 1
                animationCurlDown(likeCountLabel, String(count))
            }
        }
    }
    
    // MARK: - Properties
    
    var count: Int = 0
    
    // MARK: - Private functions
    
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
    
    // MARK: - Public functions
    
    /// Конфигурирование количества лайков и состояния лайка текущего пользователя - на данный момент используются рандомные значения
    func configure(likes count: Int, isLikedByUser: Bool) {
        self.count = count
        self.isLiked = isLikedByUser
    }
    
    // MARK: - Animation
    
    func animationFlipFromLeft(_ label: UILabel, _ text: String) {
        UIView.transition(with: label,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: { label.text = text },
                          completion: nil)
    }
    
    func animationCurlDown(_ label: UILabel, _ text: String) {
        UIView.transition(with: label,
                          duration: 0.5,
                          options: .transitionCurlDown,
                          animations: { label.text = text },
                          completion: nil)
    }
}
