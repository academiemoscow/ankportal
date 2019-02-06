//
//  File.swift
//  ankportal
//
//  Created by Олег Рачков on 31/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class NewProductInfoCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let photo = UIImageView(image: UIImage(named: "find_icon"))
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFit
        photo.sizeToFit()
        return photo
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Название продукта"
        label.font = label.font.withSize(12)
            //UIFont(name: "", size: 6)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupPhotoImageView()
        setupProductNameLabel()
    }
    
    func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
    }
    
    func setupProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor).isActive = true
        productNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        productNameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        productNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
