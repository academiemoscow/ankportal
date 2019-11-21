//
//  ProductTableViewCell.swift
//  ankportal
//
//  Created by Admin on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

protocol PreviewImageView: class {
    var previewImageView: ImageLoader { get }
}

class ProductTableViewCell: PlaceholderTableViewCell, PreviewImageView {
    
    private let productsCatalog = ProductsCatalog()
    
    private var productModel: ProductPreview?
    
    override var backgroundColorForView: UIColor {
        get {
            return UIColor.white
        }
    }
    
    lazy var _previewImageView: ImageLoader = {
        let view = ImageLoader()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    var previewImageView: ImageLoader {
        get {
            return _previewImageView
        }
    }
    
    lazy var nameTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = UIFont.defaultFont(forTextStyle: .headline)
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var oldPriceLabel: StrikeThroughLabel = {
        let label = StrikeThroughLabel()
        label.font = UIFont.defaultFont(forTextStyle: .footnote)!.withSize(15)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: .headline)!.withSize(18)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var priceVStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:  [oldPriceLabel, priceLabel])
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.fillProportionally
        return stackView
    }()
    
    lazy var toCartGroup: AddToCardButtonGroup = {
        let group = AddToCardButtonGroup()
        return group
    }()
    
    lazy var bottomHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceVStack, toCartGroup])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 60 - contentInsetLeftAndRight*2).isActive = true
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
    
    lazy var scalePropertyAnimation: UIViewPropertyAnimator = {
        
        let propertyAnimation = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
            self.containerView.transform = CGAffineTransform.identity
//            self.containerView.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 1, 0, 0)
            self.containerView.layer.opacity = 0.3
        })
        propertyAnimation.pausesOnCompletion = true
        return propertyAnimation
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    
    override func setupViews() {
        super.setupViews()
     
        containerView.addSubview(vStack)
        vStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        vStack.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -padding * 2).isActive = true
        vStack.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -padding * 2).isActive = true
    }
    
    override func prepareForReuse() {
//        scalePropertyAnimation.fractionComplete = 1.0
    }
    
    func configure(forModel model: ProductPreview) {
        toCartGroup.productID = nil
        productModel = model
        priceLabel.text = nil
        nameTextView.text = model.name
        previewImageView.image = UIImage.placeholder
        if let url = URL(string: model.previewPicture.encodeURL) {
            previewImageView.loadImageWithUrl(url)
        }
        setupVisibillity()
        loadFullInfo(forModel: model)
    }
    
    private func loadFullInfo(forModel model: ProductPreview) {
        productsCatalog.getBy(id: model.id) {[weak self] (product) in
            DispatchQueue.main.async {
                guard let product = product,
                    let modelInCell = self?.productModel,
                    product.id == modelInCell.id else {
                        return
                }
                
                self?.setPrice(product.price)
                self?.toCartGroup.productID = String(product.id)
            }
        }
    }
    
    private func setPrice(_ price: Double) {
        if (price < 50) {
            priceLabel.text = "Цена по запросу"
            return
        }
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
