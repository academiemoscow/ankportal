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
    
    private let productsCatalog = ProductsCatalog()
    
    enum State {
        case normal
        case alreadyInCart
        case unavailable
    }
    
    var productID: String? {
        didSet {
            updateStateWithCart()
            updateStackViewAndLayout()
        }
    }
    
    fileprivate var currentState: State = .unavailable
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
    
    fileprivate var qtyCartButtonWidthAnchor: NSLayoutConstraint?
    
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
        Cart.shared.add(self)
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
    }
    
    fileprivate func leftButtonHandler() {
        switch currentState {
        case .normal:
            addToCart()
        case .alreadyInCart:
            removeFromCart()
        case .unavailable:
            return
        }
    }
   
    fileprivate func rightButtonHandler() {
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
        currentState = .unavailable
        guard let productID = productID,
              let intProductID = Int(productID) else {
            return
        }
        productsCatalog.getBy(id: intProductID) {[unowned self] (product) in
            guard let product = product else {
                return
            }
            if (product.price == 0) {
                return
            }
            DispatchQueue.main.async {
                self.setState(state: self.inCart() ? .alreadyInCart : .normal)
            }
        }
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
    
    fileprivate func updateStackViewWithState() {
        updateAlpha()
        updateEnabled()
        updateTitles()
        updateConrners()
        updateWidthConstraint()
    }
    
    fileprivate func updateEnabled() {
        toCartButton.isEnabled =
            currentState == .unavailable ? false : true
    }
    
    fileprivate func updateAlpha() {
        toCartButton.alpha =
            currentState == .unavailable ? 0.1 : 1.0
    }
    
    fileprivate func updateConrners() {
        toCartButton.cornersRegions =
            currentState == .alreadyInCart ? [.topLeft, .bottomLeft] : [.topLeft, .bottomLeft, .topRight, .bottomRight]
    }
    
    fileprivate func updateWidthConstraint() {
        qtyCartButtonWidthAnchor?.constant =
            currentState == .alreadyInCart ? qtyCartButtonWidth : 0
    }
    
    private func updateTitles() {
        toCartButton.setAttributedTitle(makeAttributedTittle(for: .normal), for: .normal)
    }
    
    private func makeAttributedTittle(for state: UIControl.State) -> NSAttributedString {
        let title = getTitle()
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: UIFont.defaultFont(forTextStyle: .callout) as Any,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        
        return attributedTitle
    }
    
    fileprivate func getTitle() -> String {
        switch currentState {
        case .normal:
            return "В корзину"
        case .alreadyInCart:
            return "Убрать"
        case .unavailable:
            return "Недоступно"
        }
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

extension AddToCardButtonGroup: CartObserver {
    func cart(didUpdate cart: Cart) {
        updateStateWithCart()
    }
}

class StepperCardButtonGroup: AddToCardButtonGroup {
    
    override func leftButtonHandler() {
        switch currentState {
        case .normal:
            super.leftButtonHandler()
        case .alreadyInCart:
            decrement()
        case .unavailable:
            return
        }
    }
    
    override func getTitle() -> String {
        return ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentState = .alreadyInCart
        toCartButton.setTitle("-", for: .normal)
        qtyCartButton.setTitle("+", for: .normal)
    }
    
    override func setState(state: AddToCardButtonGroup.State) {
        currentState = state
        updateStackViewWithState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateStackViewWithState() {
        updateAlpha()
        updateEnabled()
        updateConrners()
        updateWidthConstraint()
    }
    
    override func updateWidthConstraint() {
        qtyCartButtonWidthAnchor?.constant =
            currentState == .alreadyInCart ? frame.width / 2 : 0
    }
    
    private func decrement() {
        let _ = Cart.shared.decrement(withID: productID!)
    }
    
}
