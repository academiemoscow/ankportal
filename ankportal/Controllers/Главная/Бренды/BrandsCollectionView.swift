//
//  BrandsCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit

var brandsInfo: [BrandInfo] = []
var firstRetrieveBrandsKey: Bool = true

struct  BrandInfo {
    let id: String
    let name: String
    var logoURL: String

    init(json: [String: Any]) {
        id = json["ID"] as? String ?? ""
        name = json["NAME"] as? String ?? ""
        logoURL = json["LOGO"] as? String ?? ""
    }
}

class BrandsCollectionView: UICollectionView {
    
    private let cellId = "BrandCell"
    var countOfPhotos: Int = 0
    var imageURL: String?
    let layout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        self.layout.minimumLineSpacing = 10
        self.layout.minimumInteritemSpacing = 0
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInset.left = 10
        self.contentInset.right = 10
        self.register(BrandsCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        if brandsInfo.count == 0 {
            retrieveBrandsInfo()
        }
    }
    
    func retrieveBrandsInfo() {
        if newProductsInfo.count>0 {return}
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=brandlist"
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        let newBrand = BrandInfo(json: jsonObj)
                        if firstRetrieveBrandsKey { brandsInfo.append(newBrand) }
                    }
                    if brandsInfo.count>0 {firstRetrieveBrandsKey = false}
                        DispatchQueue.main.async {
                            self?.reloadData()
                            self?.layoutIfNeeded()
                        }
                    
                    }
            } catch let jsonErr {
                print (jsonErr)
                firstRetrieveBrandsKey = true
            }
            }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension BrandsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.25, height: collectionView.frame.height*0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(brandsInfo[indexPath.row].name)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! BrandsCollectionViewCell
        cell.photoImageView.image = nil
        let brand = brandsInfo[indexPath.row]
        
        if brand.logoURL != "" {
            let imageUrl = brand.logoURL
            if let image = imageCache.object(forKey: imageUrl as AnyObject) as! UIImage? {
                
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            } else {
                let url = URL(string: imageUrl)
                URLSession.shared.dataTask(with: url!,completionHandler: {  (data, result, error) in
                    if data != nil {
                        let image = UIImage(data: data!)
                        
                        var croppedCGImage: CGImage = (image?.cgImage)!
                        var yKoef: CGFloat = 2
                        var hKoef: CGFloat = 2
                        
                        switch indexPath.row {
                        case 0:
                            yKoef = 2.2
                            hKoef = 2.2
                        case 4:
                            yKoef = 1.35
                            hKoef = 1.5
                        case 5:
                            yKoef = 1.35
                            hKoef = 1.35
                        default:
                            yKoef = 2
                            hKoef = 2
                        }
                        
                        croppedCGImage = (image?.cgImage?.cropping(to: CGRect(x: 0, y: (image?.size.height)! / yKoef, width: (image?.size.width)!, height: (image?.size.height)!/hKoef)) ?? nil)!
                        
                        let croppedImage = UIImage(cgImage: croppedCGImage)
                        
                        imageCache.setObject(croppedImage, forKey: imageUrl as AnyObject)
                        
                        DispatchQueue.main.async {
                            cell.photoImageView.image = croppedImage
                        }
                    }
                }
                ).resume()
            }
        }

        return cell
    }
    
}
