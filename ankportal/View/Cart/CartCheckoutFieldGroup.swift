//
//  CartCheckoutFieldGroup.swift
//  ankportal
//
//  Created by Admin on 04/10/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CartCheckoutFieldGroup: UIView {

    private let spacing: CGFloat = 20
    
    lazy var name: CartCheckOutField = {
        let field = CartCheckOutField()
        field.field.placeholder = "Имя"
        return field
    }()
    
    lazy var email: CartCheckOutField = {
        let field = CartCheckOutField()
        field.field.placeholder = "Email"
        return field
    }()
    
    lazy var phone: CartCheckOutField = {
        let field = CartCheckOutField()
        field.field.placeholder = "Телефон"
        return field
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [name, email, phone])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = spacing
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
