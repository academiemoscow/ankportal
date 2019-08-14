//
//  DescriptionAndCompositionCell.swift
//  ankportal
//
//  Created by Олег Рачков on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class ProductDescriptionTableViewCell: SubClassForTableViewCell {
 
    let productDescriptionTextView: UITextView = {
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
       
        self.addSubview(productDescriptionTextView)
        productDescriptionTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        productDescriptionTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        productDescriptionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        
    }
    
    override func configure(productInfo: ProductInfo) {
        productDescriptionTextView.text = productInfo.howToUse.htmlToString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
