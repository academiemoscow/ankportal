//
//  UIButtonWithBadge.swift
//  ankportal
//
//  Created by Admin on 21/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UIButtonWithBadge: UIButton {

    private var badgeView: UILabel?
    
    public func setBadge(number: Int) {
        
        let number = abs(number)
        
        badgeView?.removeFromSuperview()
        
        guard number > 0 else { return }
        
        badgeView = UILabel()
        addSubview(badgeView!)
        badgeView?.text = number > 99 ? "99+" : "\(number)"
        badgeView?.textColor = UIColor.white
        badgeView?.font = UIFont.systemFont(ofSize: 10)
        badgeView?.textAlignment = .center
        badgeView?.backgroundColor = UIColor.red
        badgeView?.layer.cornerRadius = 10
        badgeView?.clipsToBounds = true
        badgeView?.translatesAutoresizingMaskIntoConstraints = false
        badgeView?.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        badgeView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        badgeView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        badgeView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

}
