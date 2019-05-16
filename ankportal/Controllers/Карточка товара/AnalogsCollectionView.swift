//
//  AnalogsCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 11/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//


import Foundation
import  UIKit

class AnalogsCollectionView: UICollectionView {
    
    private let cellId = "newProductInfoCell"
    var countOfPhotos: Int = 0
    var imageURL: String?
    let layout = UICollectionViewFlowLayout()
    var analogs: [String] = []
    var images: [UIImage] = []
    
    lazy var restService: ANKRESTService = ANKRESTService(type: .productDetail)
    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        
        self.layout.minimumLineSpacing = frame.height*0.2
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.contentInset.left = 10
        self.contentInset.right = 10
        self.register(NewProductInfoCell.self, forCellWithReuseIdentifier: self.cellId)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AnalogsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height*0.9, height: collectionView.frame.height*0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if analogs.count == 0 {
            return 0
        } else {return analogs.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productInfoViewController = ProductInfoViewController()
        let cell = collectionView.cellForItem(at: indexPath) as! NewProductInfoCell
        let image = cell.photoImageView.image
        if image != nil {
            productInfoViewController.photoImageView.image = image
            productInfoViewController.productNameLabel.text = cell.productNameLabel.text
            productInfoViewController.productId = analogs[indexPath.row]
            firstPageController?.navigationController?.pushViewController(productInfoViewController, animated: true)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewProductInfoCell
        cell.photoImageView.image = nil
        cell.productNameLabel.text = ""

        if images.count > 0 {
            
                DispatchQueue.main.async {
                    if indexPath.row < self.images.count {
                        cell.photoImageView.image = self.images[indexPath.row]
                        cell.activityIndicator.stopAnimating()
                    }
            }
        }
        
//        if self.analogs.count>0 && self.images.count < self.analogs.count {
//            DispatchQueue.main.async {
//                    self.reloadData()
//                }
//        }
        
        
        return cell
    }
    
}
