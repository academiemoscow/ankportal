//
//  LightNavigationController.swift
//  ankportal
//
//  Created by Олег Рачков on 18/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController_swift

class LightNavigarionController: UINavigationController {
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
}

class LightESTabBarController: ESTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
}
