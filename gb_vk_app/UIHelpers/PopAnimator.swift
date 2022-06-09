//
//  PopAnimator.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 31.03.2022.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    
    private let animationDuration: TimeInterval = 1
    
    // MARK: - Functions
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // получаем оба view controller'а
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to) else { return }
        
        // добавляем destination в контейнер
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        source.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 1)
        
        // задаем итоговое местоположение для обоих view каждого из контроллеров, оно совпадает с экраном телефона
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        // трансформируем положение экрана на который нужно перейти
        let translation = CGAffineTransform(translationX: 200, y: 0)
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        destination.view.transform = translation.concatenating(scale)
        
        // запускаем анимированное возвращение экрана в итоговое положение
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
                destination.view.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.8, animations: {
                let rotation = CGAffineTransform(rotationAngle: .pi / 2)
                source.view.transform = rotation
            })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
