//
//  ProductTransitionManager.swift
//  ankportal
//
//  Created by Admin on 06/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class ProductTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    weak var imageView: PreviewImageView?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let imageView = imageView?.previewImageView
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let contrainer = transitionContext.containerView
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        imageView.frame = imageView.convert(imageView.frame, to: fromViewController.view)
        print(imageView.frame)
        fromViewController.view.backgroundColor = .red
        fromViewController.view.addSubview(imageView)
        toView.view.layer.opacity = 0.0
        
        
        contrainer.addSubview(fromViewController.view)
        contrainer.addSubview(toView.view)
        
        UIView.animate(
            withDuration: 5.5,
            animations: {
//                toView.view.layer.opacity = 1.0
                imageView.frame = CGRect(x: 0, y: 0, width: fromViewController.view.frame.width, height: 350)
        }) { _ in
            transitionContext.completeTransition(true)
        }
        
//        let duration = transitionDuration(using: transitionContext)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}
