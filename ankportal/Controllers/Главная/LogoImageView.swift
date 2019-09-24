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
    
    private var iconView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage.init(named: "anklogo")
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer.init()
        tapGestureRecognizer.addTarget(self, action: #selector(iconClick))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
   
    
    private var iconButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(image: UIImage.init(named: "anklogo"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(iconClick))

//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isUserInteractionEnabled = true
        
        button.customView?.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        
//        button.addTarget(self, action: #selector(iconClick), for: .touchUpInside)
        return button
    }()
    
    @objc func iconClick() {
           print("123123123123123123")
       }
    
    init(withIcon icon: UIImage) {
        super.init(frame: CGRect(x: 0, y: 0, width: 27, height: 25))
        addSubview(iconView)
//        iconButton.customView!.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        iconButton.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        iconButton.customView?.topAnchor.constraint(equalTo: topAnchor, constant: -12.5).isActive = true
//        iconButton.customView!.heightAnchor.constraint(equalToConstant: 25).isActive = true
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
