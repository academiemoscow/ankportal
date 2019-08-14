//
//  SubClassForTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 09/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class SubClassForTableViewCell: UITableViewCell {
    
    let rlayout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionViewInTableViewCell = {
        let collectionView = UICollectionViewInTableViewCell(frame: bounds, collectionViewLayout: rlayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configure(productInfo: ProductInfo) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
