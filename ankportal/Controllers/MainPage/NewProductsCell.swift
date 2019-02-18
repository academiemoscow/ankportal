//
//  NewProductsCell.swift
//  ankportal
//
//  Created by Олег Рачков on 05/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class NewProductsCell: UITableViewCell {
    let layout = UICollectionViewFlowLayout()
    var height: CGFloat? {
        didSet {
            newProductsCollectionView.frame.size.height = height!
            self.addSubview(newProductsCollectionView)
        }
    }
    
    var newProductsCollectionView: MainPageProductCollectionView {
        let newProducts = MainPageProductCollectionView(frame: bounds, collectionViewLayout: layout)
        newProducts.translatesAutoresizingMaskIntoConstraints = false
        return newProducts
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

