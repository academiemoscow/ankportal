//
//  File.swift
//  ankportal
//
//  Created by Олег Рачков on 31/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class NewsDetailedTextCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let photo = UIImageView(image: UIImage(named: "find_icon"))
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupPhotoImageView()
    }
    
    func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
