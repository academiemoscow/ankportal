//
//  BannerCollectionViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    var bannerInfo: BannerInfo?
    
    let containerView: ShadowView = {
        let view = ShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.shadowView.layer.cornerRadius = 10
        view.layer.borderColor = UIColor(r: 220, g: 220, b: 220).cgColor
        return view
    }()
    
    let photoImageView: ImageLoader = {
        let photo = ImageLoader()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode =  UIImageView.ContentMode.scaleAspectFill
        photo.clipsToBounds = true
        photo.layer.cornerRadius = 10
        photo.isUserInteractionEnabled = true
        return photo
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        
        backgroundColor = UIColor.white
        setupPhotoImageView()
        
        self.backgroundColor = UIColor.white
    }
    
    func fillCellData() {
        let photoURL = URL(string: (bannerInfo?.imageUrl)!)
        photoImageView.loadImageWithUrl(photoURL!)
    }

    func setupPhotoImageView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        containerView.addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
