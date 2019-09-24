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

    private let containerPadding: CGFloat = 4
    
    var id: Float?
    
//    var images: [UIImage] = []
    var imageUrl: String?
    var name: String?
    
    var productData: ProductPreview?

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
    
    let photoImageView: ImageLoader = {
        let photo = ImageLoader()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFit
        photo.sizeToFit()
        photo.isUserInteractionEnabled = true
        return photo
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        setupShadowViewContainer()
        setupPhotoImageView()
        setupProductNameLabel()
        
        
    }
    
    
    func fillCellData() {
        productNameLabel.text = productData?.name
        if let imageUrl = imageUrl {
            if let url = URL(string: imageUrl) {
                photoImageView.loadImageWithUrl(url)
            }
            return
        }
        if productData?.previewPicture != "" {
            let url = URL(string: (productData?.previewPicture)!)
            if url != nil {
                photoImageView.loadImageWithUrl(url!)
            }
        }
    }
    
    func setupShadowViewContainer() {
        contentView.addSubview(shadowViewContainer)
        shadowViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        shadowViewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        shadowViewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentInsetLeftAndRight/4).isActive = true
        shadowViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupPhotoImageView() {
        shadowViewContainer.addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: shadowViewContainer.topAnchor, constant: 5).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: shadowViewContainer.leftAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: shadowViewContainer.widthAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: shadowViewContainer.heightAnchor, multiplier: 0.6).isActive = true
    }
    
    func setupProductNameLabel() {
        shadowViewContainer.addSubview(productNameLabel)
        productNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor).isActive = true
        productNameLabel.centerXAnchor.constraint(equalTo: shadowViewContainer.centerXAnchor).isActive = true
        productNameLabel.widthAnchor.constraint(equalTo: shadowViewContainer.widthAnchor, multiplier: 0.9).isActive = true
        productNameLabel.heightAnchor.constraint(equalTo: shadowViewContainer.heightAnchor, multiplier: 0.4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
