//
//  PlaceholderTableViewCell.swift
//  ankportal
//
//  Created by Admin on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class PlaceholderTableViewCell: UITableViewCell {
    
    private let padding: CGFloat = 24
    private let cornerRadius: CGFloat = 10
    private let backgroundColorForView: UIColor = UIColor(r: 235, g: 235, b: 235)
    
    lazy var holderForImage: UIView = {
        let view = ShadowShimmerView()
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = backgroundColorForView
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [holderForImage])
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        addSubview(mainStack)
        mainStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mainStack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainStack.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -padding).isActive = true
        mainStack.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -padding).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
