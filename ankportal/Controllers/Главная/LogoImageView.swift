//
//  LogoImageView.swift
//  ankportal
//
//  Created by Олег Рачков on 13/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class UILogoImageView: UIView {
    
    private var iconView: UIImageView!
    
    init(withIcon icon: UIImage) {
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        iconView = UIImageView(image: icon)
        addSubview(iconView)
    }
    
    override func layoutSubviews() {
        iconView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
    }
    
}
