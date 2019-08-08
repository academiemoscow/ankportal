//
//  BrandInfoCell.swift
//  ankportal
//
//  Created by Олег Рачков on 08/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class BrandInfoTableViewCell: UITableViewCell {
    
    let brandDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.defaultFont(forTextStyle: .caption1)!.withSize(13)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "test"
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
        
        self.addSubview(brandImage)
        brandImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        brandImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        brandImage.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        brandImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        
    }
    
    func configure(productInfo: ProductInfo) {
        brandImage.loadImageWithUrl(URL(string: productInfo.brandInfo.detailedPictureUrl)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
