//
//  CartCheckout.swift
//  ankportal
//
//  Created by Admin on 04/10/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CartCheckout: UIScrollView {

    lazy var fields: CartCheckoutFieldGroup = {
        let fields = CartCheckoutFieldGroup()
        return fields
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(fields)
    }
    
    override func layoutSubviews() {
        fields.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
