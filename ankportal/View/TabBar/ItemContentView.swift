//
//  ItemContentView.swift
//  ankportal
//
//  Created by Олег Рачков on 29/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ItemContentView: ESTabBarItemContentView {
    
    fileprivate func setupColors() {
        textColor = UIColor.white
        highlightTextColor = UIColor.black
        backdropColor = UIColor.white
        highlightBackdropColor = UIColor.white
        iconColor = UIColor.black
        highlightIconColor = UIColor.black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupColors()
        
        let transform = CGAffineTransform.identity
        imageView.transform = transform.scaledBy(x: 1, y: 1)
    }
    
    override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
