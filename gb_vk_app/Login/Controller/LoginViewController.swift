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
        
        allAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBAction
    @IBAction func loginButtonPressed(_ sender: Any) {
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
    
    // MARK: - Segue (login, alert)
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let checkResult = checkUserData()
        
        if !checkResult {
            showLoginError()
        }
        
        return checkResult
    }
    
    func checkUserData() -> Bool {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else { return false }
        
        if login == "" && password == "" {
            return true
        } else {
            return false
        }
    }
    
    func showLoginError() {
        let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Animation
    
    func allAnimations() {
        animateLoginPasswordLabelsAppearing()
        animateTitleLabelAppearing()
        animateTextFieldsAppearing()
        animateLoginButton()
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
        let offset = view.bounds.width
        loginLabel.transform = CGAffineTransform(translationX: -offset, y: 0)
        passwordLabel.transform = CGAffineTransform(translationX: offset, y: 0)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: .curveEaseInOut,
                       animations: {
            self.loginLabel.transform = .identity
            self.passwordLabel.transform = .identity
        },
                       completion: nil)
    }
    
    func animateTitleLabelAppearing() {
        let offset = view.bounds.height / 2
        self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: { self.titleLabel.transform = .identity },
                       completion: nil)
    }
    
    func animateTextFieldsAppearing() {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = 2
        fadeInAnimation.beginTime = CACurrentMediaTime() + 1
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        fadeInAnimation.fillMode = CAMediaTimingFillMode.backwards
        
        self.loginTextField.layer.add(fadeInAnimation, forKey: nil)
        self.passwordTextField.layer.add(fadeInAnimation, forKey: nil)
    }
    
    func animateLoginButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.loginButton.layer.add(animation, forKey: nil)
    }
    
}
