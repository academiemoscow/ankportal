//
//  ProductSeminarsCVinTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 19/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class ProductSeminarsCollectionViewInTableViewCell: SubClassForTableViewCell {
    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()
    
    let layout = UICollectionViewFlowLayout()
    var mainPageController: UIViewController?
    var seminars: [String] = []
    
    lazy var productSeminarsCollectionView: ProductSeminarsCollectionView = {
        let productSeminarsCollectionView = ProductSeminarsCollectionView(frame: bounds, collectionViewLayout: layout)
        productSeminarsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return productSeminarsCollectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        productSeminarsCollectionView.educationsArray = seminars

        self.addSubview(productSeminarsCollectionView)
        productSeminarsCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        productSeminarsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        productSeminarsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        productSeminarsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.collectionView = productSeminarsCollectionView
        productSeminarsCollectionView.mainPageController = self
        
        
    }
    
    override func configure(productInfo: ProductInfo) {
        for seminar in productInfo.seminars {
            if seminar.name != "" {
                seminars.append(seminar.id)
            }
        }
        if seminars.count > 0 {
            productSeminarsCollectionView.mainPageController = self
            productSeminarsCollectionView.educationsArray = seminars
            productSeminarsCollectionView.retrieveEducationsData()
            productSeminarsCollectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
