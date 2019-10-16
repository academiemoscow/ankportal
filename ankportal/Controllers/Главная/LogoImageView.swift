//
//  LogoImageView.swift
//  ankportal
//
//  Created by Олег Рачков on 13/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class UILogoImageView: UIViewLogoBadge {
    
    init() {
            super.init(withIcon: UIImage.init(named: "anklogo")!)
            setupTapHandler()
        }
    
        
        private func setupTapHandler() {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMainPage))
            addGestureRecognizer(tapGestureRecognizer)
        }
        
        @objc private func showMainPage() {
            if let app = UIApplication.shared.delegate as? AppDelegate {
                app.tabBarController.openMain()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
       
    }

class UIViewLogoBadge: UIView {
    
    private var iconView: UIImageView!
    var badgeView: UILabel?
    
    init(withIcon icon: UIImage) {
        super.init(frame: CGRect(x: 0, y: 0, width: 24, height: 28))
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
