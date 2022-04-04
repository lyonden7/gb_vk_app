//
//  UIViewControllerExtension.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 01.04.2022.
//

import UIKit

extension UIViewController {
    func show(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}
