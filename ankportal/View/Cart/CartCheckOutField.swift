//
//  CartCheckOutField.swift
//  ankportal
//
//  Created by Admin on 04/10/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import AKMaskField

class CartCheckOutField: UIView {
    
    lazy var field: AKMaskField = {
        let field = AKMaskField()
        return field
    }()
    
    lazy var button: UIButtonRounded = {
        let button = UIButtonRounded()
        
        let attributedTitle = NSAttributedString(
            string: "OK",
            attributes: [
                NSAttributedString.Key.font: UIFont.defaultFont(forTextStyle: .callout) as Any,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = .black
        button.cornersRegions = [.topRight, .bottomRight]
        button.cornerRadius = 10
        return button
    }()

    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [field, button])
        stack.frame = frame
        stack.axis = .horizontal
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stack)
    }
    
    override func layoutSubviews() {
        stack.frame = bounds
    }
    

}
