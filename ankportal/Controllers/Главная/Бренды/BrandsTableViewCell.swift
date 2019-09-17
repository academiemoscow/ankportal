//
//  BrandsTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class BrandsTableViewCell: UITableViewCellWithCollectionView {
    
    let layout = UICollectionViewFlowLayout()
    var mainPageController: UIViewController?
    
    lazy var brandsCollectionView: BrandsCollectionView = {
        let brands = BrandsCollectionView(frame: bounds, collectionViewLayout: layout)
        brands.translatesAutoresizingMaskIntoConstraints = false
        return brands
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(brandsCollectionView)
        brandsCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        brandsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        brandsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        brandsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        brandsCollectionView.mainPageController = mainPageController
        
        self.collectionView = brandsCollectionView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
