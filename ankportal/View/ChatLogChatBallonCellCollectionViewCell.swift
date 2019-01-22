//
//  ChatLogChatBallonCellCollectionViewCell.swift
//  ankportal
//
//  Created by Admin on 22/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ChatLogChatBallonCellCollectionViewCell: UICollectionViewCell {
    
    lazy var textLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bgView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.ballonBlue
        bv.layer.cornerRadius = 16
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()

    lazy var viewWidthAnchor: NSLayoutConstraint = {
        let constraint = bgView.widthAnchor.constraint(equalToConstant: 200)
        return constraint
    }()
    
    lazy var viewLeftAnchor: NSLayoutConstraint = {
        let safeLayoutGuide = self.safeAreaLayoutGuide
        let constraint = bgView.leftAnchor.constraint(equalTo: safeLayoutGuide.leftAnchor, constant: 8)
        return constraint
    }()
    
    lazy var viewRightAnchor: NSLayoutConstraint = {
        let safeLayoutGuide = self.safeAreaLayoutGuide
        let constraint = bgView.rightAnchor.constraint(equalTo: safeLayoutGuide.rightAnchor, constant: -8)
        return constraint
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    private func setupView() {
        
        addSubview(bgView)
        self.viewRightAnchor.isActive = true
        self.viewLeftAnchor.isActive = false
        self.viewWidthAnchor.isActive = true
        bgView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(textLabel)
        textLabel.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 8).isActive = true
        textLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: bgView.widthAnchor, constant: -8).isActive = true
        textLabel.heightAnchor.constraint(equalTo: bgView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
