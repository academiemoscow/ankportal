//
//  LogoImageView.swift
//  ankportal
//
//  Created by Олег Рачков on 13/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class UILogoImageView: UIViewIconBadge {
    
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

