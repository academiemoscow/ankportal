//
//  UIViewCartIcon.swift
//  ankportal
//
//  Created by Admin on 14/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class UIViewCartIcon: UIViewIconBadge {
    
    init() {
        super.init(withIcon: UIImage.Icons.bag)
        subscribeCartUpdate()
        setupTapHandler()
        updateBadge(withCart: Cart.shared)
    }
    
    private func subscribeCartUpdate() {
        Cart.shared.add(self)
    }
    
    private func setupTapHandler() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCart))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func showCart() {
        if let app = UIApplication.shared.delegate as? AppDelegate,
           let currentViewController = app.tabBarController.selectedViewController {
            let cartViewController = LightNavigarionController(rootViewController: CartTableViewController())
            currentViewController.present(cartViewController, animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBadge(withCart cart: Cart) {
        setBadge(number: cart.count)
    }
    
    override func setBadge(number: Int64) {
        let prevLabelText = badgeView?.text
        
        super.setBadge(number: number)
        
        guard let text = prevLabelText,
            text != "\(number)" else {
                return
        }
        animate()
    }
    
    func animate() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1, 1.3, 1]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 0.1
        layer.add(animation, forKey: nil)
    }
}

extension UIViewCartIcon: CartObserver {
    func cart(didUpdate cart: Cart) {
        updateBadge(withCart: cart)
    }
}
