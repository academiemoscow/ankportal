//
//  SeminarsTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 26/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class SeminarsTableViewCell: UITableViewCellWithCollectionView {
    
    let layout = UICollectionViewFlowLayout()
    var mainPageController: UIViewController?
    
    lazy var seminarsCollectionView: EducationListCollectionView = {
        let seminars = EducationListCollectionView(frame: bounds, collectionViewLayout: layout)
        seminars.translatesAutoresizingMaskIntoConstraints = false
        return seminars
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(seminarsCollectionView)
        seminarsCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        seminarsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        seminarsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        seminarsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.collectionView = seminarsCollectionView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
