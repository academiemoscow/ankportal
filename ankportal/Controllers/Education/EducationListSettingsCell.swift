//
//  EducationListSettingsCell.swift
//  ankportal
//
//  Created by Олег Рачков on 27/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class EducationListSettingsCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.backgroundColor = UIColor.red.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
