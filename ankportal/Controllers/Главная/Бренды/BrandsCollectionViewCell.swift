//
//  BrandsCollectionViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class BrandsCollectionViewCell: UICollectionViewCell {
    
    let shadowViewContainer: UIView = {
        let shadowViewContainer = ShadowView()
        shadowViewContainer.backgroundColor = UIColor.white
        shadowViewContainer.layer.cornerRadius = 10
        shadowViewContainer.translatesAutoresizingMaskIntoConstraints = false
        shadowViewContainer.layer.borderWidth = 1
        shadowViewContainer.shadowView.layer.cornerRadius = 10
        shadowViewContainer.layer.borderColor = UIColor(r: 220, g: 220, b: 220).cgColor
        return shadowViewContainer
    }()
    
    let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = UIView.ContentMode.scaleAspectFill
        photo.clipsToBounds = true
        photo.layer.cornerRadius = 10
        photo.isUserInteractionEnabled = true
        return photo
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        backgroundColor = UIColor.white
        setupPhotoImageView()
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setupPhotoImageView() {
        addSubview(shadowViewContainer)
        shadowViewContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        shadowViewContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shadowViewContainer.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        shadowViewContainer.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        shadowViewContainer.addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: shadowViewContainer.topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: shadowViewContainer.leftAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: shadowViewContainer.widthAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: shadowViewContainer.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
