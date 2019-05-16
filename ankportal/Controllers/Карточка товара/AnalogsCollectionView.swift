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
    
    
    func retrieveImages(){
        
        for i in 0...analogs.count-1 {
            restService.clearParameters()
            restService.add(parameters: [
                RESTParameter(filter: .id, value: analogs[i]),
                RESTParameter(filter: .isTest, value: "Y")
                ])
            
            
            restService.execute (callback: { [weak self] (data, respone, error) in
                if ( error != nil ) {
                    print(error!)
                    return
                }
                
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        let productsInfo = ProductInfo(json: jsonObj)
                        
                        
                        if productsInfo.detailedPictureUrl != "" {
                            
                            let imageUrl = productsInfo.detailedPictureUrl
                            
                            if let image = imageCache.object(forKey: imageUrl as AnyObject) as! UIImage? {
                                self!.images.append(image)
                            } else {
                                let url = URL(string: imageUrl)
                                URLSession.shared.dataTask(with: url!,completionHandler: {(data, result, error) in
                                    if data != nil {
                                        let image = UIImage(data: data!)
                                        self!.images.append(image!)
                                        imageCache.setObject(image!, forKey: imageUrl as AnyObject)
                                        
                                    }
                                }
                                    ).resume()
                            }
                        }
                        
                    }
                } catch let jsonErr {
                    print (jsonErr)
                }
                
                }
            )
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewProductInfoCell
        cell.photoImageView.image = nil
        cell.productNameLabel.text = ""

        if analogs.count > 0 {
            
            if images.count < analogs.count {
                DispatchQueue.main.async {
                    cell.photoImageView.image = nil
                }
                retrieveImages()
                collectionView.reloadData()
            } else {
                DispatchQueue.main.async {
                    cell.photoImageView.image = self.images[indexPath.row]
                    cell.activityIndicator.stopAnimating()
                }
            }
            
            
//                let jsonUrlString = "https://ankportal.ru/rest/index.php?get=productdetail&id=" + analogs[indexPath.row] + "&test=Y"
//                let url: URL? = URL(string: jsonUrlString)!
//                if url != nil {
//                    URLSession.shared.dataTask(with: url!) { [weak self] (data, response, err) in
//                        guard let data = data else { return }
//                        do {
//                            if let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                                let productsInfo = ProductInfo(json: jsonObj)
//                                DispatchQueue.main.async {
//                                    if self != nil {
//                                        cell.productNameLabel.text = productsInfo.name
//                                    }
//                                }
//
//                                if productsInfo.detailedPictureUrl != "" {
//
//                                    let imageUrl = productsInfo.detailedPictureUrl
//
//                                    if let image = imageCache.object(forKey: imageUrl as AnyObject) as! UIImage? {
//                                        DispatchQueue.main.async {
//                                            cell.photoImageView.image = image
//                                            cell.activityIndicator.stopAnimating()
//                                        }
//                                    } else {
//                                        let url = URL(string: imageUrl)
//                                        URLSession.shared.dataTask(with: url!,completionHandler: {(data, result, error) in
//                                            if data != nil {
//                                                let image = UIImage(data: data!)
//                                                imageCache.setObject(image!, forKey: imageUrl as AnyObject)
//                                                DispatchQueue.main.async {
//                                                    cell.photoImageView.image = image
//                                                    cell.activityIndicator.stopAnimating()
//                                                }}
//                                        }
//                                            ).resume()
//                                    }
//                                }
//
//                            }
//                        } catch let jsonErr {
//                            print (jsonErr)
//                        }
//                        }.resume()
//                }
       
            
        }
        
        return cell
    }
    
}
