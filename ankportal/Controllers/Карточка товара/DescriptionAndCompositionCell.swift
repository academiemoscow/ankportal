//
//  DescriptionAndCompositionCell.swift
//  ankportal
//
//  Created by Олег Рачков on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class DescriptionAndCompositionTableViewCell: UITableViewCell {
    
    let productNameLabel: UITextView = {
        let productNameLabel = UITextView()
        productNameLabel.font = UIFont.preferredFont(forTextStyle: .title3).withSize(18)
        productNameLabel.isSelectable = false
        productNameLabel.isScrollEnabled = false
        productNameLabel.textAlignment = NSTextAlignment.left
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return productNameLabel
    }()
    
    let productBrandLabel: UITextView = {
        let productBrandLabel = UITextView()
        productBrandLabel.font = UIFont.preferredFont(forTextStyle: .body).withSize(14)
        productBrandLabel.isSelectable = false
        productBrandLabel.isScrollEnabled = false
        productBrandLabel.textAlignment = NSTextAlignment.left
        productBrandLabel.translatesAutoresizingMaskIntoConstraints = false
        return productBrandLabel
    }()
    
    let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .caption1).withSize(12)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(productNameLabel)
        productNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        productNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        productNameLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: contentInsetLeftAndRight).isActive = true
        
        self.addSubview(productBrandLabel)
        productBrandLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        productBrandLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        productBrandLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor,constant: contentInsetLeftAndRight).isActive = true
        
        self.addSubview(productDescriptionTextView)
        productDescriptionTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        productDescriptionTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        productDescriptionTextView.topAnchor.constraint(equalTo: productBrandLabel.bottomAnchor, constant: contentInsetLeftAndRight).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
