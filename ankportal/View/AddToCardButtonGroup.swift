//
//  AddToCardButtonGroup.swift
//  ankportal
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class AddToCardButtonGroup: UIView {

    enum State {
        case normal
        case alreadyInCart
    }
    
    private var currentState: State = .normal
    private var qtyCartButtonWidth: CGFloat = 40
    
    lazy var toCartButton: UICartButton = {
        let button = UICartButton()
        button.cornersRegions = [.topLeft, .bottomLeft, .topRight, .bottomRight]
        button.cornerRadius = 10
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.setAttributedTitle(makeAttributedTittle(for: .normal), for: .normal)
        return button
    }()
    
    private var qtyCartButtonWidthAnchor: NSLayoutConstraint?
    
    lazy var qtyCartButton: UICartButton = {
        let button = UICartButton()
        button.cornersRegions = [.topRight, .bottomRight]
        button.cornerRadius = 10
        button.backgroundColor = UIColor.orange
        
        button.setTitle("+1", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var toCartButtonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [toCartButton, qtyCartButton])
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        addSubview(toCartButtonsStack)
        toCartButtonsStack.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        toCartButtonsStack.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        qtyCartButtonWidthAnchor = qtyCartButton.widthAnchor.constraint(equalToConstant: 0)
        qtyCartButtonWidthAnchor?.isActive = true
    }
    
    public func toggleState() {
        let state: State = currentState == .normal ? .alreadyInCart : .normal
        setState(state: state)
    }
    
    public func setState(state: State) {
        currentState = state
        updateTitles()
        performAnimation()
    }
    
    private func updateTitles() {
        toCartButton.setAttributedTitle(makeAttributedTittle(for: .normal), for: .normal)
    }
    
    private func makeAttributedTittle(for state: UIControl.State) -> NSAttributedString {
        let title = currentState == .normal ? "В корзину" : "Убрать из корзины"
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: UIFont.defaultFont(forTextStyle: .callout) as Any,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        
        return attributedTitle
    }
    
    private func performAnimation() {
        self.toCartButton.cornersRegions =
            currentState == .normal ? [.topLeft, .bottomLeft, .topRight, .bottomRight] : [.topLeft, .bottomLeft]
        
        self.qtyCartButtonWidthAnchor?.constant =
            self.currentState == .normal ? 0 : self.qtyCartButtonWidth
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.49,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut],
            animations: {
                self.toCartButtonsStack.layoutIfNeeded()
        }
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
