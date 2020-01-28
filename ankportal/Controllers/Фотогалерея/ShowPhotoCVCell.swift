//
//  PhotoGalleryCollectionViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 05/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class ShowPhotoCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }()
    
    var photoImageView: UIImageView = {
        var photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = UIColor.backgroundColor
        photoImageView.isUserInteractionEnabled = true
        return photoImageView
    }()
    
    var mainPageController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        addSubview(scrollView)
        scrollView.frame = self.bounds
        scrollView.delegate = self
                
        scrollView.addSubview(photoImageView)
        photoImageView.frame = scrollView.frame
        
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
            print(scrollView.zoomScale)
            mainPageController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
