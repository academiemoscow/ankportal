//
//  BannerPlaceholderCollectionViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 30/07/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class BannerPlaceholderCollectionViewCell: UICollectionViewCell {
    
    var padding: CGFloat {
        get {
            return 24
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return 10
        }
    }
    
    var backgroundColorForView: UIColor {
        get {
            return UIColor.init(r: 240, g: 240, b: 240)
        }
    }
    
    lazy var containerView: UIView = getContainterView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    func getContainterView() -> UIView {
        let view = ShadowShimmerView()
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = backgroundColorForView
        return view
    }

    
    func setupViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
      
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
