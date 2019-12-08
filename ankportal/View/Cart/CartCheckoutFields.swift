//
//  CartCheckoutPhoneFieldTableViewCell.swift
//  ankportal
//
//  Created by Admin on 18/11/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import AKMaskField

protocol CartCheckoutCellDelegate {
    func didChangeState(_ cell: CartCheckoutFieldTableViewCell)
    func didChangeFieldState(_ field: CartCheckOutField)
    func didConfirmSend(_ cell: CartCheckoutFieldTableViewCell)
}

class CartCheckoutFieldTableViewCell: UITableViewCell, CartCheckoutFieldDelegate {

    var delegate: CartCheckoutCellDelegate?
    
    private(set) var state: CartCheckoutState = .incomplete
    
    lazy var field: CartCheckOutField = {
        let field = createAndSetupField()
        field.delegate = self
        field.field.font = UIFont.defaultFont(forTextStyle: .headline)
        field.field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    fileprivate func setup() {
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
    
    public func setState(_ state: CartCheckoutState) {
        guard self.state != state else {
            return
        }
        self.state = state
        delegate?.didChangeState(self)
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
    fileprivate func updateView() {
    }
    
    func getStatus(_ maskField: AKMaskField, _ checkOutField: CartCheckOutField) -> CartCheckoutState {
        return checkOutField.state
    }
    
    func didChangeStatus(_ field: CartCheckOutField) {
        delegate?.didChangeFieldState(field)
    }
    

}

class CartCheckPhoneFieldCell: CartCheckoutFieldTableViewCell {
    
    override func createAndSetupField() -> CartCheckOutField {
        let field = CartCheckOutField()
        field.field.maskExpression = "+7 ({ddd}) {ddd}-{dd}-{dd}"
        field.field.maskTemplate = "+7 (___) ___-__-__"
        field.field.placeholder = "Номер телефона"
        field.field.borderStyle = .roundedRect
        field.field.keyboardType = .phonePad
        return field
    }
    
}

class CartCheckEmailFieldCell: CartCheckoutFieldTableViewCell {
    
    override func createAndSetupField() -> CartCheckOutField {
        let field = CartCheckOutField()
        field.field.placeholder = "Email"
        field.field.borderStyle = .roundedRect
        field.field.keyboardType = .emailAddress
        field.delegate = self
        return field
    }
    
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    override func getStatus(_ maskField: AKMaskField, _ checkOutField: CartCheckOutField) -> CartCheckoutState {
        guard let email = maskField.text else {
            return checkOutField.state
        }
        return isValid(email) ? .complete : .incomplete
    }
    
}

class CartCheckNameFieldCell: CartCheckoutFieldTableViewCell {
    
    override func createAndSetupField() -> CartCheckOutField {
        let field = CartCheckOutField()
        field.field.placeholder = "Ваше имя"
        field.field.borderStyle = .roundedRect
        return field
    }
    
    override func getStatus(_ maskField: AKMaskField, _ checkOutField: CartCheckOutField) -> CartCheckoutState {
        guard let text = maskField.text else {
            return checkOutField.state
        }
        return text.count > 1 ? .complete : .incomplete
    }
    
}


class CartCheckoutButton: CartCheckoutFieldTableViewCell {

    private var buttonTitle = "Отправить заказ"
    private var buttonTitleIncomplete = "Заполните все поля"
    private var indicatorView = UIActivityIndicatorView(style: .gray)
    
    lazy var button: UIButtonRounded = {
        let button = UIButtonRounded()
        
        let attributedTitle = getTitle()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = .gray
        button.cornersRegions = [.allCorners]
        button.cornerRadius = 5
        button.addTarget(self, action: #selector(tapHandler), for: .touchUpInside)
        button.isEnabled = false
        
        indicatorView.hidesWhenStopped = true
        button.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        
        return button
    }()
    
    @objc private func tapHandler() {
        delegate?.didConfirmSend(self)
    }
    
    override func setup() {
        contentView.addSubview(button)
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16).isActive = true
        button.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -16).isActive = true
    }
    
    override func updateView() {
        let attributedTitle = getTitle()
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        indicatorView.stopAnimating()
        if state == .waiting {
            indicatorView.startAnimating()
        }
        
        button.backgroundColor = state == CartCheckoutState.incomplete ? UIColor.gray : UIColor.orange
        button.isEnabled = state == CartCheckoutState.complete
    }
    
    func getTitle() -> NSAttributedString {
        var btnTitle: String
        switch state {
        case .complete:
            btnTitle = buttonTitle
        case .incomplete:
            btnTitle = buttonTitleIncomplete
        default:
            btnTitle = ""
        }
        
        let attributedTitle = NSAttributedString(
            string: btnTitle,
            attributes: [
                NSAttributedString.Key.font: UIFont.defaultFont(forTextStyle: .headline) as Any,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        
        return attributedTitle
    }

}
