//
//  PhotoGalleryCollectionViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 05/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class PhotoGalleryCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }()
    
    var photoImageView: ImageLoader = {
        var photoImageView = ImageLoader()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = UIColor.backgroundColor
        photoImageView.isUserInteractionEnabled = true
        return photoImageView
    }()
    
    func configure(photoUrl: String) {
        addSubview(scrollView)
        scrollView.frame = self.bounds
        scrollView.delegate = self
        scrollView.layer.borderColor = UIColor.red.cgColor
        scrollView.layer.borderWidth = 5
        scrollView.addSubview(photoImageView)
        photoImageView.frame = scrollView.bounds

        self.scrollView.zoomScale = 1.001

        let Url = URL(string: photoUrl)
        photoImageView.loadImageWithUrl(Url!)
    }
    
    var mainPageController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
   
    }
    
    override func prepareForReuse() {
        scrollView.zoomScale = 1.001
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale == 1 {
            scrollView.zoomScale = 1.001
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
