//
//  UIPillView.swift
//  ankportal
//
//  Created by Олег Рачков on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UIPillView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
        updateSubviews()
    }

    private func updateSubviews() {
        subviews.forEach({ $0.layer.cornerRadius = self.layer.cornerRadius })
    }
}

class UIPillShadowView: UIPillView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.white
        makeShadow(
            opacity: 0.1,
            offset: CGSize(width: 0, height: 0),
            radius: 2
        )
    }
    
}
