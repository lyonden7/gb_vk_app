//
//  LoadingIndicator.swift
//  gb_vk_app
//
//  Created by Денис Васильев on 20.03.2022.
//

import UIKit

class LoadingIndicator: UIView {

    @IBOutlet weak var leftLoadingItemView: UIView?
    @IBOutlet weak var centerLoadingItemView: UIView?
    @IBOutlet weak var rightLoadingItemView: UIView?

    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftLoadingItemView?.backgroundColor = .white
        centerLoadingItemView?.backgroundColor = .white
        rightLoadingItemView?.backgroundColor = .white
        
        leftLoadingItemView?.layer.cornerRadius = bounds.height / 2
        centerLoadingItemView?.layer.cornerRadius = bounds.height / 2
        rightLoadingItemView?.layer.cornerRadius = bounds.height / 2
    }
}
