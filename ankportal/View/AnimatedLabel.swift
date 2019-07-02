//
//  AnimatedLabel.swift
//  ankportal
//
//  Created by Admin on 24/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class AnimatedOpacityLabel: UILabel {

    override var text: String? {
        didSet {
            guard let text = text, text != "" else {
                layer.opacity = 0
                return
            }
            animateOpacity()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        layer.opacity = 0
    }
    
    private func animateOpacity() {
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.layer.opacity = 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
