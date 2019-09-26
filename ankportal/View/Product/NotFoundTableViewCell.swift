//
//  NotFoundTableViewCell.swift
//  ankportal
//
//  Created by Admin on 07/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class NotFoundTableViewCell: PlaceholderTableViewCell {

    
    lazy var previewImageView: ImageLoader = {
        let view = ImageLoader()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "magnifying-glass")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var titleTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = UIFont.preferredFont(forTextStyle: .callout)
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.textAlignment = .center
        view.alpha = 0.2
        view.text = "Ничего нет :("
        return view
    }()
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previewImageView, titleTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
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
    
    override func setupViews() {
        super.setupViews()
        containerView.addSubview(vStack)
        vStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        vStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        vStack.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

}
