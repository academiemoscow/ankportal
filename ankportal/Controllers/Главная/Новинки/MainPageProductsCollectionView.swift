//
//  SwipingPhotoController.swift
//  ankportal
//
//  Created by Олег Рачков on 31/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit

var newProductsInfo: [NewProductInfo] = []
var firstRetrieveKey: Bool = true

struct NewProductInfo {
    let id: Float?
    let productName: String?
    let imageUrl: String?
    let previewText: String?
    let price: Float?
    
    init(json: [String: Any]) {
        id = json["ID"] as? Float ?? 0
        productName = json["NAME"] as? String ?? ""
        imageUrl = json["PREVIEW_PICTURE"] as? String ?? ""
        previewText = json["PREVIEW_TEXT"] as? String ?? ""
        price = json["PRICE"] as? Float ?? 0
    }
}

class MainPageProductCollectionView: UICollectionView {
    
    private let cellId = "newProductInfoCell"
    var countOfPhotos: Int = 0
    var imageURL: String?
    let layout = UICollectionViewFlowLayout()
    
    lazy var restService: ANKRESTService = ANKRESTService(type: .productList)
    
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
        if newProductsInfo.count == 0 {
            restService.add(parameter: RESTParameter(filter: .isNewProduct, value: "да"))
            retrieveNewProductsInfo()
        }
    }
    
    
    func retrieveNewProductsInfo() {
        if newProductsInfo.count>0 {return}
        
        restService.execute (callback: { [weak self] (data, respone, error) in
            if ( error != nil ) {
                print(error!)
                return
            }
            
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        let newProduct = NewProductInfo(json: jsonObj)
                        if firstRetrieveKey { newProductsInfo.append(newProduct)
                        }
                    }
                    if newProductsInfo.count>0 {firstRetrieveKey = false}
                    DispatchQueue.main.async {
                        self?.reloadData()
                        self?.layoutIfNeeded()
                    }
                }
            } catch let jsonErr {
                print (jsonErr)
                firstRetrieveKey = true
            }
            
            }
        )
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainPageProductCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height - contentInsetLeftAndRight, height: collectionView.frame.height - contentInsetLeftAndRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if newProductsInfo.count == 0 {return 10} else {return newProductsInfo.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productInfoViewController = ProductInfoViewController()
        let cell = collectionView.cellForItem(at: indexPath) as! NewProductInfoCell
        let image = cell.photoImageView.image
        if image != nil {
            productInfoViewController.photoImageView.image = image
            productInfoViewController.productNameLabel.text = cell.productNameLabel.text
            productInfoViewController.productId = String(Int(newProductsInfo[indexPath.row].id!))
            firstPageController?.navigationController?.pushViewController(productInfoViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewProductInfoCell
        cell.photoImageView.image = nil
        
        if newProductsInfo.count > 0 {
            
        DispatchQueue.main.async {
            cell.productNameLabel.text = newProductsInfo[indexPath.row].productName
            cell.id = newProductsInfo[indexPath.row].id
        }
        
        if newProductsInfo[indexPath.row].imageUrl != "" {
        
            let imageUrl = newProductsInfo[indexPath.row].imageUrl!
            
                if let image = imageCache.object(forKey: imageUrl as AnyObject) as! UIImage? {
                      DispatchQueue.main.async {
                        cell.photoImageView.image = image
                        cell.activityIndicator.stopAnimating()
                    }
                } else {
                let url = URL(string: imageUrl)
                URLSession.shared.dataTask(with: url!,completionHandler: {(data, result, error) in
                    if data != nil {
                    let image = UIImage(data: data!)
                    imageCache.setObject(image!, forKey: imageUrl as AnyObject)
                    DispatchQueue.main.async {
                        cell.photoImageView.image = image
                        cell.activityIndicator.stopAnimating()
                    }
                    }
                    }
                    ).resume()
                }
        }
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewProductInfoCell
            cell.frame.size.width = 150
            cell.activityIndicator.startAnimating() }
        
        return cell
    }
    
}
