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
        
        navigationController?.navigationBar.backgroundColor = UIColor.ankPurple
        navigationController?.navigationBar.barTintColor = UIColor.ankPurple
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.title = "Информация"
        
        let attributesForSmallTitle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.defaultFont(ofSize: 18) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.titleTextAttributes = attributesForSmallTitle
        
        let cartBarButtonItem = UIBarButtonItem(customView: UIViewCartIcon())
        navigationItem.rightBarButtonItem = cartBarButtonItem
        
        let logoView = UIBarButtonItem(customView: UILogoImageView())
        navigationItem.leftBarButtonItem = logoView
        
        let underConstractImageView = UIImageView.init(image: UIImage.init(named: "under_construct"))
        underConstractImageView.contentMode = .scaleAspectFit
        underConstractImageView.clipsToBounds = true
        underConstractImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(underConstractImageView)
        underConstractImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        underConstractImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        underConstractImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        underConstractImageView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }
    
    
}
