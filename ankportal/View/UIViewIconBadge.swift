//
//  UIViewIconBadge.swift
//  ankportal
//
//  Created by Admin on 13/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UIViewIconBadge: UIView {
    
    private var iconView: UIImageView!
    fileprivate var badgeView: UILabel?
    
    init(withIcon icon: UIImage) {
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        iconView = UIImageView(image: icon)
        addSubview(iconView)
    }
    
    override func layoutSubviews() {
        iconView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
    }
    
    public func setBadge(number: Int64) {
        
        let number = abs(number)
        
        badgeView?.removeFromSuperview()
        
        badgeView = UILabel()
        addSubview(badgeView!)
        badgeView?.text = "\n" + (number > 99 ? "99+" : "\(number)")
        badgeView?.textColor = UIColor.white
        badgeView?.font = UIFont.defaultFont(ofSize: 12)
        badgeView?.textAlignment = .center
        badgeView?.backgroundColor = .clear
        badgeView?.frame = bounds
        badgeView?.numberOfLines = 2
    }

}

class UIViewCartIcon: UIViewIconBadge {
    
    init() {
        super.init(withIcon: UIImage.Icons.bag)
        subscribeCartUpdate()
        updateBadge(withCart: Cart.shared)
    }
    
    private func subscribeCartUpdate() {
        Cart.shared.add(self)
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
