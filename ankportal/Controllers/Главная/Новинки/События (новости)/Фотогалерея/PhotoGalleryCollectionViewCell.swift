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
        photoImageView.backgroundColor = UIColor.backgroundColor
        photoImageView.isUserInteractionEnabled = true
        return photoImageView
    }()
    
    func configure(photoUrl: String) {
        addSubview(scrollView)
        scrollView.frame = self.bounds
        scrollView.delegate = self
        scrollView.addSubview(photoImageView)
        photoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        photoImageView.frame = scrollView.frame
        photoImageView.clipsToBounds = true
        
        self.scrollView.zoomScale = 1.001
        
        if photoUrl != "" {
            let Url = URL(string: photoUrl)
            photoImageView.loadImageWithUrl(Url!)
        }
        layoutSubviews()
    }
    
    var mainPageController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        layoutSubviews()
    }
    
    override func prepareForReuse() {
        scrollView.zoomScale = 1.001
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale == 1 {
            scrollView.zoomScale = 1.001
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
           if scrollView.zoomScale == 1.001 {
               mainPageController?.dismiss(animated: true, completion: nil)
           }
       }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
    override func layoutSubviews() {
        scrollView.frame = bounds
        photoImageView.frame = scrollView.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
