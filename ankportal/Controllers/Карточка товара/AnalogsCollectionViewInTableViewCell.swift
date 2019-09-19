//
//  AnalogsCollectionViewInTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class AnalogsCollectionViewInTableViewCell: SubClassForTableViewCell {
    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()

    let layout = UICollectionViewFlowLayout()
    var mainPageController: UIViewController?
    
    var analogs: [String] = []
    var images: [UIImage] = []
    var imagesUrl: [String] = []
    var names: [String: String] = [:]
    
    lazy var analogsCollectionView: AnalogsCollectionView = {
        let analogs = AnalogsCollectionView(frame: bounds, collectionViewLayout: layout)
        analogs.translatesAutoresizingMaskIntoConstraints = false
        return analogs
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(analogsCollectionView)
        analogsCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        analogsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        analogsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        analogsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.collectionView = analogsCollectionView
        analogsCollectionView.mainPageController = self
        
        analogsCollectionView.analogs = analogs
        
    }
    
    override func configure(productInfo: ProductInfo) {
        analogs = productInfo.analogs
        analogsCollectionView.mainPageController = self
        analogsCollectionView.analogs = analogs
        analogsCollectionView.retrieveProductsData()
        analogsCollectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

