//
//  CartCheckoutPhoneFieldTableViewCell.swift
//  ankportal
//
//  Created by Admin on 18/11/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import AKMaskField

class CartCheckoutFieldTableViewCell: UITableViewCell {

    lazy var field: CartCheckOutField = {
        let field = createAndSetupField()
        field.field.font = UIFont.defaultFont(forTextStyle: .headline)
        field.field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(field)
        field.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        field.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16).isActive = true
        field.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -16).isActive = true
    }
    
    fileprivate func createAndSetupField() -> CartCheckOutField {
        return CartCheckOutField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class CartCheckPhoneFieldCell: CartCheckoutFieldTableViewCell {
    
    override func createAndSetupField() -> CartCheckOutField {
        let field = CartCheckOutField()
        field.field.maskExpression = "+7 ({ddd}) {ddd}-{dd}-{dd}"
        field.field.maskTemplate = "+7 (___) ___-__-__"
        field.field.placeholder = "Номер телефона"
        field.field.borderStyle = .roundedRect
        return field
    }
    
}

class CartCheckEmailFieldCell: CartCheckoutFieldTableViewCell {
    
    override func createAndSetupField() -> CartCheckOutField {
        let field = CartCheckOutField()
        field.field.placeholder = "Email"
        field.field.borderStyle = .roundedRect
        return field
    }
    
}
