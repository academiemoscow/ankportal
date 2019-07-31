//
//  NewsTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class NewsTableViewCell: UITableViewCellWithCollectionView {
    
    let layout = UICollectionViewFlowLayout()
    var mainPageController: UIViewController?
    
    lazy var newsCollectionView: NewsCollectionView = {
        let news = NewsCollectionView(frame: bounds, collectionViewLayout: layout)
        news.mainPageController = mainPageController
        news.translatesAutoresizingMaskIntoConstraints = false
        return news
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(newsCollectionView)
        newsCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        newsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        newsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        newsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.collectionView = newsCollectionView

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
