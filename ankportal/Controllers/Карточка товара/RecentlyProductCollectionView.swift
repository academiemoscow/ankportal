//
//  RecentlyProductCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 17/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class RecentlyProductCollectionView: UICollectionViewInTableViewCell {
    var mainPageController: RecentlyProductCollectionViewInTableViewCell?
    
    private let cellId = "newProductInfoCell"
    private let placeholderCellId = "placeholderInfoCell"
    var countOfPhotos: Int = 0
    var imageURL: String?
    let layout = UICollectionViewFlowLayout()
    var recentlyProductsArray: [String] = []
    var images: [UIImage] = []
    var imagesUrl: [String] = []
    var ids: [String] = []
    
    var data: [ProductPreview] = []
    
    var firstRetrieveKey: Bool = true
    var endOfRetrieveKey: Bool = false
    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        
        self.layout.minimumLineSpacing = frame.height*0.2
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.contentInset.left = 10
        self.contentInset.right = 10
        self.register(NewProductInfoCell.self, forCellWithReuseIdentifier: self.cellId)
        self.register(EducationInfoPlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: self.placeholderCellId)

        let defaultKey = "RecentlyProductId"
        let findDefaultsArray = UserDefaults.standard.array(forKey: defaultKey)
        
        if findDefaultsArray != nil {
            recentlyProductsArray = findDefaultsArray as! [String]
        }
        
        retrieveProductsData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func retrieveProductsData() {
        
        let request = ANKRESTService(type: .productList)
        request.add(parameters: recentlyProductsArray.mapToRESTParameters(forRESTFilter: .fid))
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
    
}


extension RecentlyProductCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height*0.9, height: collectionView.frame.height*0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if (data.count == 0) {
                return 5
            } else {
                return data.count }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row + 1 > data.count { return }
        let productInfoViewController = ProductInfoTableViewController()
        
        let cell = collectionView.cellForItem(at: indexPath) as! NewProductInfoCell
        let image = cell.photoImageView.image
        if image != nil {
            productInfoViewController.productId = String(Int(data[indexPath.row].id))
            firstPageController?.navigationController?.pushViewController(productInfoViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (data.count == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: placeholderCellId, for: indexPath) as! EducationInfoPlaceholderCollectionViewCell
            return cell
        } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewProductInfoCell
        
        cell.productData = data[indexPath.row]
        cell.fillCellData()
        
            return cell }
    }
    
}
