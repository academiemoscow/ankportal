//
//  ImageZoomAnimationController.swift
//  ankportal
//
//  Created by Олег Рачков on 30/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ImageZoomAnimationController: NSObject {
    
    private let animationDuration: Double
    private let animationType: AnimationType
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType

    }
    
}

extension ImageZoomAnimationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch  animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            print(2)
        }
        
    }
    
    
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
                
        UIView.animate(withDuration: animationDuration , delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations:{
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
    }
    
    
}
