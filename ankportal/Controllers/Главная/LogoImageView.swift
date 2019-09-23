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
//        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.addTarget(self, action: #selector(iconClick))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    @objc func iconClick() {
        print("123123123123123123")
    }
    
    private var iconButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage.init(named: "anklogo"), for: .normal)
        button.backgroundColor = UIColor.red
        return button
    }()
    
    init(withIcon icon: UIImage) {
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
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
