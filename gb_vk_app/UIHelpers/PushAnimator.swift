//
//  PushAnimator.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 31.03.2022.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // получаем оба view controller'а
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to) else { return }
        
        // добавляем destination в контейнер
        transitionContext.containerView.addSubview(destination.view)
        
        source.view.layer.anchorPoint = CGPoint(x: 1, y: 1)
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        
        // задаем итоговое местоположение для обоих view каждого из контроллеров, оно совпадает с экраном телефона
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        // трансформируем положение экрана на который нужно перейти
        destination.view.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        // запускаем анимированное возвращение экрана в итоговое положение
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75, animations: {
                let translation = CGAffineTransform(translationX: 200, y: 0)
                let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                source.view.transform = translation.concatenating(scale)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8, animations: {
                destination.view.transform = .identity
            })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
