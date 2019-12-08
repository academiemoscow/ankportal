//
//  CartCheckOutField.swift
//  ankportal
//
//  Created by Admin on 04/10/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import AKMaskField

enum CartCheckoutState {
    case complete
    case incomplete
    case waiting
}

protocol CartCheckoutFieldDelegate {
    func getStatus(_ maskField: AKMaskField, _ checkOutField: CartCheckOutField) -> CartCheckoutState
    func didChangeStatus(_ field: CartCheckOutField)
}

class CartCheckOutField: UIView {
    
    private(set) var state: CartCheckoutState = .incomplete
    
    var delegate: CartCheckoutFieldDelegate?
    
    lazy var field: AKMaskField = {
        let field = AKMaskField()
        field.maskDelegate = self
        field.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        return field
    }()
    
    lazy var button: UIButtonRounded = {
        let button = UIButtonRounded()
        
        let attributedTitle = NSAttributedString(
            string: "OK",
            attributes: [
                NSAttributedString.Key.font: UIFont.defaultFont(forTextStyle: .callout) as Any,
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = .clear
        button.cornersRegions = [.allCorners]
        button.cornerRadius = 10
        return button
    }()

    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [field])
        stack.frame = frame
        stack.axis = .horizontal
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @objc private func textDidChanged(_ field: AKMaskField) {
        setState(delegate?.getStatus(field, self) ?? state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setState(_ state: CartCheckoutState) {
        guard self.state != state else {
            return
        }
        self.state = state
        delegate?.didChangeStatus(self)
        updateView()
    }
    
    private func updateView() {
        let attributedTitle = NSAttributedString(
            string: "OK",
            attributes: [
                NSAttributedString.Key.font: UIFont.defaultFont(forTextStyle: .callout) as Any,
                NSAttributedString.Key.foregroundColor: state == CartCheckoutState.complete ? UIColor.green : UIColor.gray
            ]
        )
        
        button.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    private func setupViews() {
        addSubview(stack)
        field.addSubview(button)
        button.heightAnchor.constraint(equalTo: field.heightAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func layoutSubviews() {
        stack.frame = bounds
    }
    

}

extension CartCheckOutField: AKMaskFieldDelegate {
    func maskField(_ maskField: AKMaskField, didChangedWithEvent event: AKMaskFieldEvent) {
        switch maskField.maskStatus {
        case .complete:
            setState(.complete)
        default:
            setState(.incomplete)
        }
    }
}
