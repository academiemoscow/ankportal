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
    fileprivate var qtyCartButtonWidth: CGFloat {
        return 40
    }
    
    var qtyMeasureText = "шт"
    
    fileprivate var toCartButtonWidthAnchor: NSLayoutConstraint?
    
    lazy var toCartButton: UICartButton = {
        let button = UICartButton()
        button.cornersRegions = [.topLeft, .bottomLeft, .topRight, .bottomRight]
        button.cornerRadius = 10
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.setTitle(getTitle(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapHandler(_:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    fileprivate var qtyCartButtonWidthAnchor: NSLayoutConstraint?
    
    lazy var qtyCartButton: UICartButton = {
        let button = UICartButton()
        button.cornersRegions = [.topLeft, .bottomLeft, .topRight, .bottomRight]
        button.cornerRadius = 10
        button.backgroundColor = UIColor.orange
        button.tag = 2
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapHandler(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate var qtyLabelWidthAnchor: NSLayoutConstraint?
    
    lazy var qtyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFontBold(forTextStyle: .body)
        label.textAlignment = .center
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(qtyTapHandler))
        label.addGestureRecognizer(tapGesture)
        
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var toCartButtonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [toCartButton, qtyLabel, qtyCartButton])
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
        
        qtyCartButtonWidthAnchor = qtyCartButton.widthAnchor.constraint(equalToConstant: 0)
        qtyCartButtonWidthAnchor?.isActive = true
        
        qtyLabelWidthAnchor = qtyLabel.widthAnchor.constraint(equalToConstant: 0)
        qtyLabelWidthAnchor?.isActive = true
        
        toCartButtonWidthAnchor = toCartButton.widthAnchor.constraint(equalToConstant: frame.width)
        toCartButtonWidthAnchor?.isActive = true
    }
    
    override func layoutSubviews() {
        updateWidthConstraint()
    }
    
    @objc private func qtyTapHandler(_ sender: UILabel) {
        if let productId = productID, let id = Int(productId) {
            productsCatalog.getBy(id: id) {[weak self] (product) in
                if let product = product {
                    let alertController = UIAlertController(title: product.name, message: "Укажите желаемое количество", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "ОК", style: .default) { (_) in
                        if let textField = alertController.textFields?.first {
                            if let text = textField.text, let qty = Int64(text) {
                                let _ = Cart.shared.set(Qty: qty, forID: productId)
                            }
                        }
                    }
                    
                    let cancel = UIAlertAction(title: "Отмена", style: .cancel)
                    
                    alertController.addAction(ok)
                    alertController.addAction(cancel)
                    
                    DispatchQueue.main.async {
                        alertController.addTextField { (textField) in
                            textField.text = "\(Cart.shared.quantity(forId: productId))"
                            textField.keyboardType = .decimalPad
                        }
                        self?.firstAvailableViewController()?.present(alertController, animated: true)
                    }
                }
            }
        }
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
            decrement()
        case .unavailable:
            return
        }
    }
   
    fileprivate func rightButtonHandler() {
        addToCart()
    }
    
    fileprivate func addToCart() {
        guard let productID = productID else {
            return
        }
        Cart.shared.addProduct(withID: productID)
    }
    
    fileprivate func decrement() {
        guard let productID = productID else {
            return
        }
        
        if (Cart.shared.quantity(forId: productID) > 1) {
            let _ = Cart.shared.decrement(withID: productID)
        } else {
            removeFromCart()
        }
    }
    
    fileprivate func removeFromCart() {
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
        DispatchQueue.main.async {
            self.setState(state: self.inCart() ? .alreadyInCart : .normal)
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
    }
    
    fileprivate func updateWidthConstraint() {
        qtyCartButtonWidthAnchor?.constant =
            currentState == .alreadyInCart ? qtyCartButtonWidth : 0
        toCartButtonWidthAnchor?.constant =
            currentState == .alreadyInCart ? qtyCartButtonWidth : frame.width
        
        let labelWidth = frame.width - qtyCartButtonWidth * 2
        qtyLabelWidthAnchor?.constant =
            currentState == .alreadyInCart && labelWidth > 0 ? labelWidth : 0
    }
    
    private func updateTitles() {
        toCartButton.setTitle(getTitle(), for: .normal)
        
        guard let productID = productID else {
            qtyLabel.text = ""
            return
        }
        qtyLabel.text = "\(Cart.shared.quantity(forId: productID)) \(qtyMeasureText)"
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
            return "-"
        case .unavailable:
            return "Недоступно"
        }
    }
    
    private func performAnimation() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentState = .alreadyInCart
        toCartButton.setTitle("-", for: .normal)
        qtyCartButton.setTitle("+", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromCart() {
        let alertController = UIAlertController(title: "Удаление товара", message: "Вы действительно хотите удалить выбранный товар из корзины", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Да", style: .default) { (_) in
            super.removeFromCart()
        }
        let no = UIAlertAction(title: "Нет", style: .cancel)
        alertController.addAction(yes)
        alertController.addAction(no)
        self.firstAvailableViewController()?.present(alertController, animated: true)
    }
}
