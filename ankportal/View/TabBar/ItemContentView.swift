//
//  ItemContentView.swift
//  ankportal
//
//  Created by Admin on 25/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ItemContentView: ESTabBarItemContentView {

    fileprivate func setupColors() {
        textColor = UIColor.white
        highlightTextColor = UIColor.white
        backdropColor = UIColor.blue
        highlightBackdropColor = UIColor.black
        iconColor = UIColor.white
        highlightIconColor = UIColor.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupColors()
        
        let transform = CGAffineTransform.identity
        imageView.transform = transform.scaledBy(x: 1, y: 1)
    }
    
    override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        imageView.transform = imageView.transform.scaledBy(x: 0.8, y: 0.8)
        UIView.commitAnimations()
        completion?()
    }
    
    override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bounceAnimation() {
        imageView.transform = CGAffineTransform.identity
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = 0.6
        impliesAnimation.calculationMode = .cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
        
    }
    
}
