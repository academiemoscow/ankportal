//
//  ShimmerView.swift
//  ankportal
//
//  Created by Admin on 03/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ShimmerView: UIView {
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [backgroundColor?.cgColor, UIColor.lightGray.cgColor, backgroundColor?.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width * 3, height: self.bounds.height)
        gradientLayer.transform = CATransform3DMakeRotation(90 * CGFloat.pi / 180, 0, 0, 1)
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.gray
        
        setupGradient()
        runAnimation()
    }
    
    func setupGradient() {
        self.clipsToBounds = true
        self.layer.addSublayer(gradientLayer)
    }
    
    func runAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -frame.width * 3
        animation.toValue = frame.width
        animation.duration = 1
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
