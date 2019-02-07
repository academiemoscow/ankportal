//
//  SwipingPhotoController.swift
//  ankportal
//
//  Created by Олег Рачков on 31/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

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
    var newProductsInfo: [NewProductInfo] = []
    
    let layout = UICollectionViewFlowLayout()
    
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        self.layout.minimumLineSpacing = 40
        
        self.register(NewProductInfoCell.self, forCellWithReuseIdentifier: self.cellId)
        retrieveNewProductsInfo()
    }
    
    
    func retrieveNewProductsInfo() {
        
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=productlist"
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        DispatchQueue.main.async {
                            let newProduct = NewProductInfo(json: jsonObj)
                            self?.newProductsInfo.append(newProduct)
  
                            self?.reloadData()
                            self?.layoutIfNeeded()
//
                        }
                        
                    }
                    
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainPageProductCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.countOfPhotos
        return newProductsInfo.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewProductInfoCell
        cell.frame.size.width = 150
        
        DispatchQueue.main.async {
            cell.productNameLabel.text = self.newProductsInfo[indexPath.row].productName
        }
       // cell.backgroundColor = UIColor.red
        if self.newProductsInfo[indexPath.row].imageUrl == "" {
        } else {
        
        let imageUrl = self.newProductsInfo[indexPath.row].imageUrl!
            
            if let image = imageCache.object(forKey: imageUrl as AnyObject) as! UIImage? {
                cell.photoImageView.image = image
            } else {
            let url = URL(string: imageUrl)
            URLSession.shared.dataTask(with: url!,completionHandler: {(data, result, error) in
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                    cell.activityIndicator.stopAnimating()
                }
                }
                ).resume()
            }
            
        }
            
        
        return cell
    }
    
    
    
}
