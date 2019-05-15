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
    
    lazy var previewImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.clear
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
        view.font = UIFont.defaultFont(ofSize: 18)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var verticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
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
//        previewImageView.image = imageCache.object(forKey: model.previewPicture as AnyObject) as? UIImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
