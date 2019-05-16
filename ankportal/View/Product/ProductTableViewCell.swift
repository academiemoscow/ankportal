//
//  ProductTableViewCell.swift
//  ankportal
//
//  Created by Admin on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ProductTableViewCell: PlaceholderTableViewCell {

    override var backgroundColorForView: UIColor {
        get {
            return UIColor.white
        }
    }
    
    lazy var previewImageView: ImageLoader = {
        let view = ImageLoader()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var previewTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var nameTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = UIFont.defaultFont(ofSize: 20)
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var toCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("В корзину", for: .normal)
        button.backgroundColor = UIColor(r: 159, g: 131, b: 174)
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var verticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextView, previewImageView, toCartButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    override func getContainterView() -> UIView {
        let view = ShadowView()
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = backgroundColorForView
        return view
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func setupViews() {
        super.setupViews()
        containerView.addSubview(verticalStack)
        verticalStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        verticalStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        verticalStack.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -padding * 2).isActive = true
        verticalStack.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -padding * 2).isActive = true
    }
    
    func configure(forModel model: ProductPreview) {
        nameTextView.text = model.name
        if let url = URL(string: model.previewPicture.encodeURL) {
            previewImageView.loadImageWithUrl(url)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
