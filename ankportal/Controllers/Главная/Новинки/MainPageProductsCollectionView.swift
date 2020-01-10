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

class MainPageProductCollectionView: UICollectionViewInTableViewCell {
    var firstRetrieveKey: Bool = true

    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()

    var data: [ProductPreview] = []
    
    override var dataIsEmpty: Bool {
        get {
            return data.isEmpty
        }
    }

    private let cellId = "newProductInfoCell"
    private let placeholderCellId = "placeholderCellId"
    var countOfPhotos: Int = 0
    var imageURL: String?
    let layout = UICollectionViewFlowLayout()
    
    lazy var trestService: ANKRESTService = ANKRESTService(type: .productList)
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        self.backgroundColor = UIColor.backgroundColor
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        
        self.layout.minimumLineSpacing = frame.height*0.2
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.contentInset.left = contentInsetLeftAndRight
        self.contentInset.right = contentInsetLeftAndRight
        
        self.register(NewProductInfoCell.self, forCellWithReuseIdentifier: self.cellId)
        self.register(EducationInfoPlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: self.placeholderCellId)
        
        if newProductsInfo.count == 0 {
            trestService.add(parameter: RESTParameter(filter: .isNewProduct, value: "да"))
            retrieveNewProductsInfo()
        }
    }
    
    
    func retrieveNewProductsInfo() {
        let request = ANKRESTService(type: .productList)
        request.add(parameter: RESTParameter(filter: .isNewProduct, value: "да"))
        restQueue.add(request: request) {[weak self] (data, response, error) in
            guard let data = data else {
                return
            }
            if let data = try? JSONDecoder().decode([ProductPreview].self, from: data) {
                self?.data = data
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fetchData() {
        newProductsInfo = []
        firstRetrieveKey = true
        retrieveNewProductsInfo()
    }
    
}

extension MainPageProductCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height - contentInsetLeftAndRight, height: collectionView.frame.height - contentInsetLeftAndRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.count == 0 {return 5} else {return data.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row + 1 > data.count { return }
        let cell = collectionView.cellForItem(at: indexPath) as! NewProductInfoCell
        let image = cell.photoImageView.image
        if image != nil && newProductsInfo.count - 1 <= indexPath.row {
            imageCache.setObject(image!, forKey: data[indexPath.row].previewPicture as AnyObject)
        }
        
        let productInfoViewController = ProductInfoTableViewController()
        productInfoViewController.productId = String(Int(data[indexPath.row].id))
        firstPageController?.navigationController?.pushViewController(productInfoViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if data.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewProductInfoCell

            cell.productData = data[indexPath.row]
            cell.fillCellData()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.placeholderCellId, for: indexPath) as! EducationInfoPlaceholderCollectionViewCell
            return cell
        }
       
    }
    
}
