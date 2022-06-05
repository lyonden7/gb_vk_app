//
//  PhotoViewController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 23.03.2022.
//

import UIKit
import Kingfisher

/// Контроллер для отображения одной фотографии на весь экран, с возможностью перелистывания вперед-назад
class PhotoViewController: UIViewController {
    
    enum AnimationDirection {
        case left
        case right
    }
    
    @IBOutlet weak var bigPhotoImageView: UIImageView! {
        didSet {
            bigPhotoImageView.isUserInteractionEnabled = true
        }
    }
    
    private let additionalImageView = UIImageView()
    
    public var photos = [Photo]()
    public var selectedPhotoIndex: Int = 0
    
    private var propertyAnimator: UIViewPropertyAnimator!
    private var animationDirection: AnimationDirection = .left
    
    private let duration = 0.7 // продолжительность
    private let delay = 0.0 // задержка
    private let additionalImageViewScaleX: CGFloat = 1.3 // масштаб по X
    private let additionalImageViewScaleY: CGFloat = 1.3 // масштаб по Y
    private let bigPhotoImageViewScaleX: CGFloat = 0.6 // масштаб по X
    private let bigPhotoImageViewScaleY: CGFloat = 0.6 // масштаб по Y
    private let additionalImageViewTranslationX: CGFloat = 1.3 // сдвиг по X
    private let additionalImageViewTranslationY: CGFloat = 150 // сдвиг по Y
    private let bigPhotoImageViewTranslationX: CGFloat = 1.5 // сдвиг по X
    private let bigPhotoImageViewTranslationY: CGFloat = 100 // сдвиг по Y
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard !photos.isEmpty else { return }
        bigPhotoImageView.kf.setImage(with: URL(string: photos[selectedPhotoIndex].photoUrlString))
        
        let leftSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(photoSwipedLeft(_:)))
        leftSwipeGR.direction = .left
        bigPhotoImageView.addGestureRecognizer(leftSwipeGR)
        
        view.insertSubview(additionalImageView, belowSubview: bigPhotoImageView)
        additionalImageView.contentMode = .scaleAspectFit
        additionalImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            additionalImageView.leadingAnchor.constraint(equalTo: bigPhotoImageView.leadingAnchor),
            additionalImageView.trailingAnchor.constraint(equalTo: bigPhotoImageView.trailingAnchor),
            additionalImageView.topAnchor.constraint(equalTo: bigPhotoImageView.topAnchor),
            additionalImageView.bottomAnchor.constraint(equalTo: bigPhotoImageView.bottomAnchor)
        ])
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        view.addGestureRecognizer(panGR)
    }
    
    // MARK: - Swipe functions
    
    @objc func photoSwipedLeft(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        guard selectedPhotoIndex + 1 <= photos.count - 1 else { return }
        
        additionalImageView.transform = CGAffineTransform(translationX: additionalImageViewTranslationX * self.additionalImageView.bounds.width, y: additionalImageViewTranslationY).concatenating(CGAffineTransform(scaleX: additionalImageViewScaleX, y: additionalImageViewScaleY))
        additionalImageView.kf.setImage(with: URL(string: photos[selectedPhotoIndex + 1].photoUrlString))
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            self.bigPhotoImageView.transform = CGAffineTransform(translationX: -self.bigPhotoImageViewTranslationX * self.bigPhotoImageView.bounds.width, y: -self.bigPhotoImageViewTranslationY).concatenating(CGAffineTransform(scaleX: self.bigPhotoImageViewScaleX, y: self.bigPhotoImageViewScaleY))
            self.additionalImageView.transform = .identity
        }) { _ in
            self.selectedPhotoIndex += 1
            self.bigPhotoImageView.kf.setImage(with: URL(string: self.photos[self.selectedPhotoIndex].photoUrlString))
            self.bigPhotoImageView.transform = .identity
            self.additionalImageView.image = nil
        }
    }
    
    @IBAction func photoSwipedRight(_ sender: UISwipeGestureRecognizer) {
        guard selectedPhotoIndex >= 1 else { return }
        
        additionalImageView.transform = CGAffineTransform(translationX: -additionalImageViewTranslationX * self.additionalImageView.bounds.width, y: additionalImageViewTranslationY).concatenating(CGAffineTransform(scaleX: additionalImageViewScaleX, y: additionalImageViewScaleY))
        additionalImageView.kf.setImage(with: URL(string: photos[selectedPhotoIndex - 1].photoUrlString))
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            self.bigPhotoImageView.transform = CGAffineTransform(translationX: self.bigPhotoImageViewTranslationX * self.bigPhotoImageView.bounds.width, y: -self.bigPhotoImageViewTranslationY).concatenating(CGAffineTransform(scaleX: self.bigPhotoImageViewScaleX, y: self.bigPhotoImageViewScaleY))
            self.additionalImageView.transform = .identity
        }) { _ in
            self.selectedPhotoIndex -= 1
            self.bigPhotoImageView.kf.setImage(with: URL(string: self.photos[self.selectedPhotoIndex].photoUrlString))
            self.bigPhotoImageView.transform = .identity
            self.additionalImageView.image = nil
        }
    }
    
    @objc func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
        case .began:
            if panGestureRecognizer.translation(in: view).x > 0 {
                guard selectedPhotoIndex >= 1 else { return }
                animationDirection = .right
                // начальная трансформация
                additionalImageView.transform = CGAffineTransform(translationX: -additionalImageViewTranslationX * self.additionalImageView.bounds.width, y: additionalImageViewTranslationY).concatenating(CGAffineTransform(scaleX: additionalImageViewScaleX, y: additionalImageViewScaleY))
                additionalImageView.kf.setImage(with: URL(string: photos[selectedPhotoIndex - 1].photoUrlString))
                // создаем аниматор для движения направо
                propertyAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: {
                    self.bigPhotoImageView.transform = CGAffineTransform(translationX: self.bigPhotoImageViewTranslationX * self.bigPhotoImageView.bounds.width, y: -self.bigPhotoImageViewTranslationY).concatenating(CGAffineTransform(scaleX: self.bigPhotoImageViewScaleX, y: self.bigPhotoImageViewScaleY))
                    self.additionalImageView.transform = .identity
                })
                propertyAnimator.addCompletion { position in
                    switch position {
                    case .end:
                        self.selectedPhotoIndex -= 1
                        self.bigPhotoImageView.kf.setImage(with: URL(string: self.photos[self.selectedPhotoIndex].photoUrlString))
                        self.bigPhotoImageView.transform = .identity
                        self.additionalImageView.image = nil
                    case .start:
                        self.additionalImageView.transform = CGAffineTransform(translationX: -self.additionalImageViewTranslationX * self.additionalImageView.bounds.width, y: self.additionalImageViewTranslationY).concatenating(CGAffineTransform(scaleX: self.additionalImageViewScaleX, y: self.additionalImageViewScaleY))
                    case .current:
                        break
                    @unknown default:
                        break
                    }
                }
            } else {
                guard selectedPhotoIndex + 1 <= photos.count - 1 else { return }
                animationDirection = .left
                // начальная трансформация
                additionalImageView.transform = CGAffineTransform(translationX: additionalImageViewTranslationX * self.additionalImageView.bounds.width, y: additionalImageViewTranslationY).concatenating(CGAffineTransform(scaleX: additionalImageViewScaleX, y: additionalImageViewScaleY))
                additionalImageView.kf.setImage(with: URL(string: photos[selectedPhotoIndex + 1].photoUrlString))
                // создаем аниматор для движения налево
                propertyAnimator = UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut, animations: {
                    self.bigPhotoImageView.transform = CGAffineTransform(translationX: -self.bigPhotoImageViewTranslationX * self.bigPhotoImageView.bounds.width, y: -self.bigPhotoImageViewTranslationY).concatenating(CGAffineTransform(scaleX: self.bigPhotoImageViewScaleX, y: self.bigPhotoImageViewScaleY))
                    self.additionalImageView.transform = .identity
                })
                propertyAnimator.addCompletion { position in
                    switch position {
                    case .end:
                        self.selectedPhotoIndex += 1
                        self.bigPhotoImageView.kf.setImage(with: URL(string: self.photos[self.selectedPhotoIndex].photoUrlString))  
                        self.bigPhotoImageView.transform = .identity
                        self.additionalImageView.image = nil
                    case .start:
                        self.additionalImageView.transform = CGAffineTransform(translationX: self.additionalImageViewTranslationX * self.additionalImageView.bounds.width, y: self.additionalImageViewTranslationY).concatenating(CGAffineTransform(scaleX: self.additionalImageViewScaleX, y: self.additionalImageViewScaleY))
                    case .current:
                        break
                    @unknown default:
                        break
                    }
                }
            }    
        case .changed:
            guard let propertyAnimator = self.propertyAnimator else { return }
            switch animationDirection {
            case .left:
                let percent = min(max(0, -panGestureRecognizer.translation(in: view).x / 200), 1)
                propertyAnimator.fractionComplete = percent
            case .right:
                let percent = min(max(0, panGestureRecognizer.translation(in: view).x / 200), 1)
                propertyAnimator.fractionComplete = percent
            }
        case .ended:
            guard let propertyAnimator = self.propertyAnimator else { return }
            if propertyAnimator.fractionComplete > 0.33 {
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
            } else {
                propertyAnimator.isReversed = true
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
            }
        default:
            break
        }
    }
}
