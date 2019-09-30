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
        gradientLayer.frame = CGRect(
            x: bounds.width / 2 - bounds.height / 2,
            y: bounds.height / 2 - bounds.width / 2,
            width: bounds.height,
            height: bounds.width
        )
        gradientLayer.transform = CATransform3DMakeRotation(90 * CGFloat.pi / 180, 0, 0, 1)

        return gradientLayer
        
    }
    
    fileprivate func getAnimation() -> CAAnimation {
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fromValue = -frame.width
        animation.toValue = frame.width
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        return animation
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ShadowView: ObservingBoundsChangeView {
    
    lazy var shadowView: UIView = {
        let view = UIView()
        return view
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
    }
    
    private func addShadowView() {
        shadowView.removeFromSuperview()
        shadowView.frame = bounds
        shadowView.layer.cornerRadius = layer.cornerRadius
        shadowView.makeShadow(
            color:  UIColor.black,
            opacity : 0.15,
            offset  : CGSize(width: 0, height: 0),
            radius  : 3
        )
        shadowView.backgroundColor = backgroundColor
        insertSubview(shadowView, at: 0)
    }
    
    override func boundsDidChanged() {
        addShadowView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShadowShimmerView: ShadowView {
    
    private lazy var shimmerView: ShimmerView = {
        let view = ShimmerView(frame: bounds)
        return view
    }()
    
    override func boundsDidChanged() {
        super.boundsDidChanged()
        shimmer()
    }

    func shimmer() {
        addShimmerView()
    }
    
    private func addShimmerView() {
        shimmerView.removeFromSuperview()
        shimmerView.frame = bounds
        shimmerView.layer.cornerRadius = layer.cornerRadius
        shimmerView.backgroundColor = backgroundColor
        shimmerView.shimmer()
        addSubview(shimmerView)
    }
    
}
