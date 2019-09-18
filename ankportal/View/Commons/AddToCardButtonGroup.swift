//
//  AddToCardButtonGroup.swift
//  ankportal
//
//  Created by Admin on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class AddToCardButtonGroup: UIView {
    
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    enum State {
        case normal
        case alreadyInCart
    }
    
    var productID: String? {
        didSet {
            updateStateWithCart()
            updateStackViewAndLayout()
        }
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
        button.addTarget(self, action: #selector(tapHandler(_:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    private var qtyCartButtonWidthAnchor: NSLayoutConstraint?
    
    lazy var qtyCartButton: UICartButton = {
        let button = UICartButton()
        button.cornersRegions = [.topRight, .bottomRight]
        button.cornerRadius = 10
        button.backgroundColor = UIColor.orange
        button.tag = 2
        button.setTitle("+1", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapHandler(_:)), for: .touchUpInside)
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
        toCartButtonsStack.heightAnchor.constraint(equalToConstant: 60 - contentInsetLeftAndRight*2).isActive = true
        toCartButtonsStack.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        qtyCartButtonWidthAnchor = qtyCartButton.widthAnchor.constraint(equalToConstant: 0)
        qtyCartButtonWidthAnchor?.isActive = true
    }
    
    @objc private func tapHandler(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            leftButtonHandler()
        case 2:
            rightButtonHandler()
        default:
            return
        }
        impactGenerator.impactOccurred()
        updateStateWithCart()
        setState(state: currentState)
    }
    
    private func leftButtonHandler() {
        switch currentState {
        case .normal:
            addToCart()
        case .alreadyInCart:
            removeFromCart()
        }
    }
   
    private func rightButtonHandler() {
        addToCart()
    }
    
    private func addToCart() {
        guard let productID = productID else {
            return
        }
        Cart.shared.addProduct(withID: productID)
    }
    
    private func removeFromCart() {
        guard let productID = productID else {
            return
        }
        Cart.shared.removeProduct(withID: productID)
    }
    
    public func toggleState() {
        let state: State = currentState == .normal ? .alreadyInCart : .normal
        setState(state: state)
    }
    
    public func setState(state: State) {
        currentState = state
        updateStackViewWithState()
        performAnimation()
    }
    
    private func updateStateWithCart() {
        currentState = inCart() ? .alreadyInCart : .normal
    }
    
    private func inCart() -> Bool {
        guard let productID = self.productID else {
            return false
        }
        
        let cart = Cart.shared
        return cart.inCart(productID: productID)
    }
    
    private func updateStackViewAndLayout() {
        updateStackViewWithState()
        layoutIfNeeded()
    }
    
    private func updateStackViewWithState() {
        updateTitles()
        updateConrners()
        updateWidthConstraint()
    }
    
    private func updateConrners() {
        toCartButton.cornersRegions =
            currentState == .normal ? [.topLeft, .bottomLeft, .topRight, .bottomRight] : [.topLeft, .bottomLeft]
    }
    
    private func updateWidthConstraint() {
        qtyCartButtonWidthAnchor?.constant =
            currentState == .normal ? 0 : qtyCartButtonWidth
    }
    
    private func updateTitles() {
        toCartButton.setAttributedTitle(makeAttributedTittle(for: .normal), for: .normal)
    }
    
    private func makeAttributedTittle(for state: UIControl.State) -> NSAttributedString {
        let title = currentState == .normal ? "В корзину" : "Убрать"
        
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
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.49,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut],
            animations: {
                self.layoutIfNeeded()
        }
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
