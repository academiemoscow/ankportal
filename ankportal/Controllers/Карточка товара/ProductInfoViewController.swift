//
//  ProductInfoViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 15/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class ProductInfoViewController: UIViewController {
  
    let productPhotoView: UIView = {
        let productPhotoNameView = UIView()
        productPhotoNameView.backgroundColor = UIColor.white
        productPhotoNameView.layer.cornerRadius = 10
        productPhotoNameView.translatesAutoresizingMaskIntoConstraints = false
        return productPhotoNameView
    }()
    
    let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.image = UIImage(named: "doctor")
        photo.layer.cornerRadius = 20
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    let productNameLabel: UITextView = {
        let productNameLabel = UITextView()
        productNameLabel.font = UIFont.systemFont(ofSize: 14)
        productNameLabel.isSelectable = false
        productNameLabel.isScrollEnabled = false
        productNameLabel.backgroundColor = backgroundColor
        productNameLabel.textAlignment = NSTextAlignment.left
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return productNameLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = backgroundColor
        self.title = "Товар"
        
        view.addSubview(productPhotoView)
        productPhotoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        productPhotoView.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.maxY)! + 10).isActive = true
        productPhotoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45).isActive = true
        productPhotoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45).isActive = true
        productPhotoView.backgroundColor = UIColor.white
        productPhotoView.layer.shadowColor = UIColor.red.cgColor
        productPhotoView.layer.shadowOpacity = 0.5
        productPhotoView.layer.shadowOffset = CGSize(width: 1, height: 10)
        productPhotoView.layer.shadowRadius = 5
        productPhotoView.layer.shadowPath = UIBezierPath(rect: productPhotoView.bounds).cgPath
        productPhotoView.layer.shouldRasterize = true
        productPhotoView.layer.rasterizationScale = UIScreen.main.scale
        
        productPhotoView.addSubview(photoImageView)
        photoImageView.centerXAnchor.constraint(equalTo: productPhotoView.centerXAnchor).isActive = true
        photoImageView.centerYAnchor.constraint(equalTo: productPhotoView.centerYAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: productPhotoView.widthAnchor, multiplier: 0.9).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: productPhotoView.heightAnchor,multiplier: 0.9).isActive = true
        
        view.addSubview(productNameLabel)
        productNameLabel.leftAnchor.constraint(equalTo: productPhotoView.rightAnchor, constant: 10).isActive = true
        productNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        productNameLabel.topAnchor.constraint(equalTo: productPhotoView.topAnchor,constant: -5).isActive = true
        productNameLabel.bottomAnchor.constraint(equalTo: productPhotoView.centerYAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
        
}
