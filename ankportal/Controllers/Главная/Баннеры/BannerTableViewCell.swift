//
//  BannerTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class BannerTableViewCell: UITableViewCellWithCollectionView {
    
    let layout = UICollectionViewFlowLayout()
    var mainPageController: UIViewController?
    
    lazy var bannersCollectionView: MainPageBannersCollectionView = {
        let banners = MainPageBannersCollectionView(frame: bounds, collectionViewLayout: layout)
        banners.translatesAutoresizingMaskIntoConstraints = false
        return banners
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(bannersCollectionView)
        bannersCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bannersCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bannersCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bannersCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.collectionView = bannersCollectionView
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
