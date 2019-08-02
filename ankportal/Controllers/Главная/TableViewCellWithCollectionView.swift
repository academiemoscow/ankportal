//
//  TableViewCellWithCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 31/07/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class UITableViewCellWithCollectionView: UITableViewCell {
    
    let rlayout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionViewInTableViewCell = {
        let collectionView = UICollectionViewInTableViewCell(frame: bounds, collectionViewLayout: rlayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        if collectionView.dataIsEmpty {
            collectionView.fetchData()
        }
    }
}
