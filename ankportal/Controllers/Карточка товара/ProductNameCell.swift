//
//  DescriptionAndCompositionCell.swift
//  ankportal
//
//  Created by Олег Рачков on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class ProductNameTableViewCell: SubClassForTableViewCell {
    
    let productNameLabel: UITextView = {
        let productNameLabel = UITextView()
        productNameLabel.font = UIFont.defaultFont(forTextStyle: .title3)!.withSize(20)
        productNameLabel.isSelectable = false
        productNameLabel.isScrollEnabled = false
        productNameLabel.textAlignment = NSTextAlignment.left
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return productNameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(productNameLabel)
        productNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        productNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        productNameLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: contentInsetLeftAndRight).isActive = true
    }
    
    override func configure(productInfo: ProductInfo) {
        productNameLabel.text = productInfo.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
