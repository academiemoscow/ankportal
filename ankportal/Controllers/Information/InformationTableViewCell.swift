//
//  AboutCompanyTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 27.11.2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class InformationTableViewCell: UITableViewCell {
    let rlayout = UICollectionViewFlowLayout()
       
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.defaultFont(forTextStyle: .headline)
        titleLabel.textColor = UIColor.gray
        titleLabel.layer.masksToBounds = true
        titleLabel.text = "Название кнопки"
        return titleLabel
    }()
    
    var titleImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "anklogo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
   
    var goButtonImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "arrow")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        
        addSubview(goButtonImageView)
        goButtonImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        goButtonImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        goButtonImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        goButtonImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true

        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: goButtonImageView.leftAnchor, constant: -contentInsetLeftAndRight).isActive = true
        
    }
   
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
       
}
