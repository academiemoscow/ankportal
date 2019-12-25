//
//  CartTableViewCell.swift
//  ankportal
//
//  Created by Admin on 26/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    private let spacing: CGFloat = 8
    
    private var data: (Product, Int64)?
    
    private lazy var pictureView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.lightGray.withAlphaComponent(0.2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return imageView
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: .body)
        label.numberOfLines = 2
        return label
    }()
    
    private let brandName: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: .footnote)
        label.textColor = UIColor.gray
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var stepper: StepperCardButtonGroup = {
        let buttons = StepperCardButtonGroup()
        buttons.translatesAutoresizingMaskIntoConstraints = false
        buttons.widthAnchor.constraint(equalToConstant: 140).isActive = true
        buttons.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return buttons
    }()
    
    private lazy var nameStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [name, brandName])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = spacing
        return stackView
    }()
    
    private let qtyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: .headline)?.withSize(14)
        label.textColor = UIColor.black
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: .headline)?.withSize(14)
        label.textColor = UIColor.black
        return label
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFontBold(forTextStyle: .headline)?.withSize(14)
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.text = "x"
        label.font = UIFont.defaultFont(forTextStyle: .headline)?.withSize(14)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var topStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pictureView, nameStack])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var priceStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stepper, xLabel, priceLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = spacing
        return stackView
    }()
    
    private lazy var bottomStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceStack, sumLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = spacing
        return stackView
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStack, bottomStack])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupViews()
        Cart.shared.add(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        selectionStyle = .none
    }
    
    func setupViews() {
        contentView.addSubview(vStack)
        vStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        vStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -spacing * 2).isActive = true
        vStack.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -spacing * 2).isActive = true
    }
    
    func configure(forData data: (Product, Int64)) {
        self.data = data
        let (product, _) = data
        
        stepper.productID = String(product.id)

        name.text = product.name
        brandName.text = product.brand?.name
        
        setPriceQty()
        loadImage(byString: product.detailPicture)
        
    }
    
    private func setPriceQty() {
        qtyLabel.text = ""
        priceLabel.text = ""
        sumLabel.text = ""
        xLabel.isHidden = false
        
        guard let product = data?.0 else {
            return
        }
        
        let qty = Cart.shared.quantity(forId: String(product.id))
        
        let formatter = CurrencyFormatter()
        formatter.minimumFractionDigits = 2
        
        qtyLabel.text = "\(qty)"
        
        if (product.price < 50) {
            xLabel.isHidden = true
            priceLabel.text = ""
            sumLabel.text = "Цена по запросу"
            return
        }
        
        priceLabel.text = "\(formatter.beautify(product.price)) RUB"
        sumLabel.text = "\(formatter.beautify(product.price * Double(qty))) RUB"
    }
    
    private func loadImage(byString urlString: String) {
        pictureView.image = nil
        pictureView.image = UIImage.placeholder
        if let url = URL(string: urlString) {
            pictureView.loadImageWithUrl(url)
        }
    }

}

extension CartTableViewCell: CartObserver {
    func cart(didUpdate cart: Cart) {
        setPriceQty()
    }
    
}
