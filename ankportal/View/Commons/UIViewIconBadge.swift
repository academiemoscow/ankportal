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
    var badgeView: UILabel?
    
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
        badgeView?.textColor = UIColor.black
        badgeView?.font = UIFont.defaultFont(ofSize: 12)
        badgeView?.textAlignment = .center
        badgeView?.backgroundColor = .clear
        badgeView?.frame = bounds
        badgeView?.numberOfLines = 2
    }

}
