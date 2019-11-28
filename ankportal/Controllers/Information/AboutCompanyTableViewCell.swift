//
//  AboutCompanyTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 27.11.2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class AboutCompanyTableViewCell: UITableViewCell {
    let rlayout = UICollectionViewFlowLayout()
       
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.defaultFont(forTextStyle: .largeTitle)
        titleLabel.textColor = UIColor.gray
        titleLabel.layer.masksToBounds = true
        return titleLabel
    }()
    
    var titleImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "anklogo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
//        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(titleImageView)
        titleImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        titleImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: contentInsetLeftAndRight).isActive = true
        titleImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        titleImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
    }
   
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
       
}
