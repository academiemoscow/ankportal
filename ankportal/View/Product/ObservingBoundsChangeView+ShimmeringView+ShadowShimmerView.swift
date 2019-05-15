//
//  ShimmeringView.swift
//  ankportal
//
//  Created by Admin on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
class ObservingBoundsChangeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObservingToBounds()
    }
    
    final func addObservingToBounds() {
        self.addObserver(self, forKeyPath: "self.bounds", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath {
            if (keyPath == "self.bounds") {
                boundsDidChanged()
            }
        }
    }
    
    func boundsDidChanged() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ShimmerView: ObservingBoundsChangeView {
    
    convenience init() {
       self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    override func boundsDidChanged() {
        super.boundsDidChanged()
        shimmer()
    }
    
    func shimmer() {
        
        layer.sublayers = nil
        createAndAddGradient()
        
    }
    
    fileprivate func createAndAddGradient() {
        
        let gradientLayer = getGradientLayer()
        layer.addSublayer(gradientLayer)
        
        let animation = getAnimation()
        gradientLayer.add(animation, forKey: nil)
        
    }
    
    fileprivate func getGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            backgroundColor?.cgColor ?? UIColor.clear.cgColor,
            UIColor.white.cgColor,
            backgroundColor?.cgColor ?? UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.height * 2, height: bounds.width * 2)
        gradientLayer.transform = CATransform3DMakeRotation(90 * CGFloat.pi / 180, 0, 0, 1)

        return gradientLayer
        
    }
    
    fileprivate func getAnimation() -> CAAnimation {
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -frame.width * 5
        animation.toValue = frame.width
        animation.duration = 1
        animation.repeatCount = .infinity
        return animation
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ShadowView: ObservingBoundsChangeView {
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    override func boundsDidChanged() {
        makeShadow(
            color:  UIColor.lightGray,
            opacity : 0.8,
            offset  : CGSize(width: 0, height: -2),
            radius  : 6
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShadowShimmerView: ShadowView {
    
    override func boundsDidChanged() {
        super.boundsDidChanged()
        
        shimmer()
    }

    func shimmer() {
        removeAllSubviews()
        addSubview(getShimmerView())
    }
    
    private func getShimmerView() -> ShimmerView {
        let shimmerView = ShimmerView(frame: bounds)
        shimmerView.layer.cornerRadius = layer.cornerRadius
        shimmerView.backgroundColor = backgroundColor
        shimmerView.shimmer()
        return shimmerView
    }
    
}
