//
//  RecentlyProductCollectionViewInTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 17/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class RecentlyProductCollectionViewInTableViewCell: SubClassForTableViewCell {
    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()
    
    let layout = UICollectionViewFlowLayout()
    var mainPageController: UIViewController?
    
    var analogs: [String] = []
    var images: [UIImage] = []
    var imagesUrl: [String] = []
    var names: [String: String] = [:]
    
    
    lazy var recentlyProductsCollectionView: RecentlyProductCollectionView = {
        let recentlyProductsCollectionView = RecentlyProductCollectionView(frame: bounds, collectionViewLayout: layout)
        recentlyProductsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return recentlyProductsCollectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(recentlyProductsCollectionView)
        recentlyProductsCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        recentlyProductsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        recentlyProductsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recentlyProductsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.collectionView = recentlyProductsCollectionView
        recentlyProductsCollectionView.mainPageController = self
        
 
    }
    
    override func configure(productInfo: ProductInfo) {
        analogs = productInfo.analogs
        recentlyProductsCollectionView.mainPageController = self
        recentlyProductsCollectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
