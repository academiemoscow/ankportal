//
//  DescriptionAndCompositionCell.swift
//  ankportal
//
//  Created by Олег Рачков on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class ProductCompositionTableViewCell: SubClassForTableViewCell {
    
    let productCompositionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.defaultFont(forTextStyle: .caption1)!.withSize(13)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(productCompositionTextView)
        productCompositionTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        productCompositionTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        productCompositionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        
    }
    
    override func configure(productInfo: ProductInfo) {
        if productInfo.sostav.htmlToString == "" {
            productCompositionTextView.text = "-"
        } else {
            productCompositionTextView.text = productInfo.sostav.htmlToString
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
