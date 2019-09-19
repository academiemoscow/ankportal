//
//  MainPageBannerCell.swift
//  ankportal
//
//  Created by Олег Рачков on 01/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class NewProductsTableViewCell: UITableViewCellWithCollectionView {
    
    let layout = UICollectionViewFlowLayout()
    var mainPageController: UIViewController?
    
    lazy var newProductsCollectionView: MainPageProductCollectionView = {
        let newProducts = MainPageProductCollectionView(frame: bounds, collectionViewLayout: layout)
        newProducts.translatesAutoresizingMaskIntoConstraints = false
        return newProducts
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
  
        self.addSubview(newProductsCollectionView)
        newProductsCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        newProductsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        newProductsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        newProductsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.collectionView = newProductsCollectionView
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
