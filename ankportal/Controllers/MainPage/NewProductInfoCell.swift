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
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFit
        photo.sizeToFit()
        return photo
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.tintColor = UIColor.black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupPhotoImageView()
        setupProductNameLabel()
        activityIndicator.removeFromSuperview()
        addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    override func prepareForReuse() {
        activityIndicator.removeFromSuperview()
        addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
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
