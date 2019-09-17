//
//  File.swift
//  Chat
//
//  Created by Олег Рачков on 24/01/2019.
//  Copyright © 2019 Олег Рачков. All rights reserved.
//

import Foundation
import UIKit

class ElseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Другое"
        
        let attributesForSmallTitle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.defaultFont(ofSize: 18) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.titleTextAttributes = attributesForSmallTitle
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let cartBarButtonItem = UIBarButtonItem(customView: UIViewCartIcon())
        navigationItem.rightBarButtonItem = cartBarButtonItem
        
        let logoView = UILogoImageView(withIcon: UIImage.init(named: "anklogo")!)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoView)
    }
    
    
}
