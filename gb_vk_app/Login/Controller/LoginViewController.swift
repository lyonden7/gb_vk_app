//
//  LoginViewController.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 31.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: LoadingIndicator!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeydoard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_ :)))
        self.view.addGestureRecognizer(recognizer)
        
        allAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBAction
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
              login == "",
              password == "" else {
                  show(message: "Введены неверные данные")
                  return
              }
        
        let tabbarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
        tabbarVC.transitioningDelegate = self
        self.navigationController?.pushViewController(tabbarVC, animated: true)
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    @objc func hideKeydoard() {
        self.scrollView?.endEditing(true)
    }
    
    // MARK: - Animation
    
    func allAnimations() {
        animateLoginPasswordLabelsAppearing()
        animateTitleLabelAppearing()
        animateTextFieldsAppearing()
        loadingAnimation()
    }
    
    func loadingAnimation() {
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       options: [.autoreverse, .repeat],
                       animations: { self.loadingIndicator.leftLoadingItemView?.alpha = 0 },
                       completion: nil)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0.3,
                       options: [.autoreverse, .repeat],
                       animations: { self.loadingIndicator.centerLoadingItemView?.alpha = 0 },
                       completion: nil)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0.6,
                       options: [.autoreverse, .repeat],
                       animations: { self.loadingIndicator.rightLoadingItemView?.alpha = 0 },
                       completion: nil)
    }
    
    func animateLoginPasswordLabelsAppearing() {
        let offset = abs(self.loginLabel.frame.midY - self.passwordLabel.frame.midY)
        self.loginLabel.transform = CGAffineTransform(translationX: 0, y: offset)
        self.passwordLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
        
        UIView.animateKeyframes(withDuration: 1,
                                delay: 1,
                                options: .calculationModePaced,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.5,
                               animations: {
                self.loginLabel.transform = CGAffineTransform(translationX: 150, y: 50)
                self.passwordLabel.transform = CGAffineTransform(translationX: -150, y: -50)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5,
                               relativeDuration: 0.5,
                               animations: {
                self.loginLabel.transform = .identity
                self.passwordLabel.transform = .identity
            })
        },
                                completion: nil)
    }
    
    func animateTitleLabelAppearing() {
        let offset = view.bounds.height / 2
        self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
        
        let animator = UIViewPropertyAnimator(duration: 1,
                                              dampingRatio: 0.5,
                                              animations: { self.titleLabel.transform = .identity })
        
        animator.startAnimation(afterDelay: 1)
    }
    
    func animateTextFieldsAppearing() {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.stiffness = 150
        scaleAnimation.mass = 2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1
        animationGroup.beginTime = CACurrentMediaTime() + 1
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationGroup.fillMode = CAMediaTimingFillMode.backwards
        animationGroup.animations = [fadeInAnimation, scaleAnimation]
        
        self.loginTextField.layer.add(animationGroup, forKey: nil)
        self.passwordTextField.layer.add(animationGroup, forKey: nil)
    }
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactiveAnimator?.startAnimation()
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                         dampingRatio: 0.5,
                                                         animations: {
                self.loginButton.transform = CGAffineTransform(translationX: 0, y: 150)
            })
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = translation.y / 100
        case .ended:
            interactiveAnimator.stopAnimation(true)
            interactiveAnimator.addAnimations {
                self.loginButton.transform = .identity
            }
            interactiveAnimator.startAnimation()
        default:
            return
        }
    }
}

extension LoginViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PushAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PopAnimator()
    }
}
