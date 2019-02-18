//
//  File.swift
//  ankportal
//
//  Created by Олег Рачков on 31/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class ShowNextNewsCell: UITableViewCell {
    

    let showNextNewsButton: UILabel = {
        
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = UIColor.gray
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        label.text = "∨ показать ещё ∨"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        
        setupShowNextNewsButton()
    }
    
    func setupShowNextNewsButton() {
        addSubview(showNextNewsButton)
        showNextNewsButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        showNextNewsButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        showNextNewsButton.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        showNextNewsButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
