//
//  BrandInfoCell.swift
//  ankportal
//
//  Created by Олег Рачков on 08/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class BrandInfoTableViewCell: SubClassForTableViewCell {
    
    let brandDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.defaultFont(forTextStyle: .caption1)!.withSize(13)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let brandImage: ImageLoader = {
        let photo = ImageLoader()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.emptyImage = nil
        photo.contentMode = .scaleAspectFit
        photo.clipsToBounds = true
        photo.sizeToFit()
        photo.isUserInteractionEnabled = true
        return photo
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(brandDescriptionTextView)
        brandDescriptionTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        brandDescriptionTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        brandDescriptionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        brandDescriptionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        
    }
    
    override func configure(productInfo: ProductInfo) {
        self.brandDescriptionTextView.text = productInfo.brandInfo.detailText.htmlToString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
