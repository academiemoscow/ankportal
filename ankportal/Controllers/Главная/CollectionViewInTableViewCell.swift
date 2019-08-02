//
//  CollectionViewInTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 31/07/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class UICollectionViewInTableViewCell: UICollectionView {
    
    var dataIsEmpty: Bool {
        get {
            return true
        }
    }
    
    var doReload: Bool = false
    
    let rlayout = UICollectionViewFlowLayout()
    
    lazy var restService: ANKRESTService = ANKRESTService(type: .bannersInfo)
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: rlayout)
        rlayout.scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchData() {
    }
    
}
