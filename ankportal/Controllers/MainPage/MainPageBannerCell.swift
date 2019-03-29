//
//  MainPageBannerCell.swift
//  ankportal
//
//  Created by Олег Рачков on 01/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class MainPageBannerCell: UITableViewCell {
    
    var bannerImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "main_page_banner")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(bannerImageView)
        
        
        bannerImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bannerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        bannerImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bannerImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
