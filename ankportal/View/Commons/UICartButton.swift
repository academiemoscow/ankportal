//
//  CustomButton.swift
//  ankportal
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UIButtonRounded: UIButton {
    var cornerRadius: CGFloat = 0
    var cornersRegions: UIRectCorner = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: cornersRegions, radius: cornerRadius)
    }
}

class UICartButton: UIButtonRounded {
    private var _backgroundColor: UIColor?
    
    var highlitedBackgroundColor: UIColor = .red
    
    override var backgroundColor: UIColor? {
        didSet {
            if (!self.isHighlighted) {
                self._backgroundColor = self.backgroundColor
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = self.isHighlighted ? self.highlitedBackgroundColor : self._backgroundColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    private func setupButton() {
        layer.cornerRadius = 0
        setTitle("В корзину", for: .normal)
        highlitedBackgroundColor = .ballonGrey
        backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
