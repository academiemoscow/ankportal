//
//  CheckmarkButton.swift
//  ankportal
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CheckmarkButton: UIButton {

    var isChecked: Bool = false {
        didSet {
            updateBacgroundImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = nil
        tintColor = .black
        setTitle(nil, for: .normal)
        updateBacgroundImage()
    }
    
    private func updateBacgroundImage() {
        let icon = isChecked ? UIImage.Icons.minusRound : UIImage.Icons.plusRound
        setBackgroundImage(icon, for: .normal)
    }
    
}
