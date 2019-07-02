//
//  ProductTableViewCell.swift
//  ankportal
//
//  Created by Admin on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ProductTableViewCell: PlaceholderTableViewCell {

    private let productsCatalog = ProductsCatalog()
    
    private var productModel: ProductPreview?
    
    override var backgroundColorForView: UIColor {
        get {
            return UIColor.white
        }
    }
    
    lazy var noImagePlaceholder: UIImage? = {
        let image = UIImage(named: "photography")?.withRenderingMode(.alwaysTemplate)
        return image
    }()
    
    lazy var previewImageView: ImageLoader = {
        let view = ImageLoader()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var nameTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var toCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("В корзину", for: .normal)
        button.backgroundColor = UIColor.ankPurple
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(self.addToCartHandler), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var oldPriceLabel: StrikeThroughLabel = {
        let label = StrikeThroughLabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(15)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        label.textColor = UIColor.ankPurple
        return label
    }()
    
    lazy var priceVStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [oldPriceLabel, priceLabel])
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.fillProportionally
        return stackView
    }()
    
    lazy var bottomHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceVStack, toCartButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextView, previewImageView, bottomHStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.fill
        stackView.spacing = 20
        return stackView
    }()
    
    override func getContainterView() -> UIView {
        let view = ShadowView()
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = backgroundColorForView
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(r: 220, g: 220, b: 220).cgColor
        return view
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func setupViews() {
        super.setupViews()
        containerView.addSubview(vStack)
        vStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        vStack.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -padding * 2).isActive = true
        vStack.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -padding * 2).isActive = true
    }
    
    func configure(forModel model: ProductPreview) {
        productModel = model
        priceLabel.text = nil
        nameTextView.text = model.name
        previewImageView.image = noImagePlaceholder
        if let url = URL(string: model.previewPicture.encodeURL) {
            previewImageView.loadImageWithUrl(url)
        }
        setupVisibillity()
        loadFullInfo(forModel: model)
    }
    
    private func loadFullInfo(forModel model: ProductPreview) {
        productsCatalog.getBy(id: model.id) {[weak self] (product) in
            guard let product = product,
                  let modelInCell = self?.productModel,
                  product.id == modelInCell.id else {
                return
            }
            
            DispatchQueue.main.async {
                self?.setPrice(product.price)
            }
        }
    }
    
    private func setPrice(_ price: Double) {
        let formatter = CurrencyFormatter()
        formatter.minimumFractionDigits = 2
        priceLabel.text = "\(formatter.beautify(price)) RUB"
        setupVisibillity()
    }
    
    private func setupVisibillity() {
        setupVisibillityBottomHStack()
        layoutIfNeeded()
    }
    
    private func setupVisibillityBottomHStack() {
        toCartButton.isEnabled = false
        guard let price = priceLabel.text, price.count > 0 else {
            return
        }
        toCartButton.isEnabled = true
    }
    
    @objc private func addToCartHandler() {
        performAnimation()
    }
    
    private func performAnimation() {
        let label = getLabelForAddToCartAction()
        animateLabelAndRemove(label)
    }
    
    private func getLabelForAddToCartAction() -> UILabel {
        let label = UILabel()
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: toCartButton.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: toCartButton.centerYAnchor).isActive = true
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.text = "+1"
        return label
    }
    
    private func animateLabelAndRemove(_ label: UILabel) {
        UIView.animate(withDuration: 0.7, animations: {
            label.transform = CGAffineTransform(translationX: 0, y: -200)
            label.layer.opacity = 0.0
        }) { _ in
            label.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
