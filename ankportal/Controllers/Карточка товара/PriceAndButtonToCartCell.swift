//
//  PriceAndButtonToCartCell.swift
//  ankportal
//
//  Created by Олег Рачков on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class PriceAndButtonToCartTableViewCell: SubClassForTableViewCell {
    
    lazy var toCartButton:AddToCardButtonGroup = {
        let button = AddToCardButtonGroup()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.ankPurple
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: .headline)!.withSize(18)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let articleLabel: UILabel = {
        let articleText = UILabel()
        articleText.text = ""
        articleText.numberOfLines = 1
        articleText.font = UIFont.defaultFont(forTextStyle: .footnote)
        articleText.textColor = UIColor.lightGray
        articleText.translatesAutoresizingMaskIntoConstraints = false
        return(articleText)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(articleLabel)
        articleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        articleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        articleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsetLeftAndRight+1).isActive = true
        articleLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        self.addSubview(priceLabel)
        priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        priceLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.addSubview(toCartButton)
        toCartButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        toCartButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        toCartButton.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        toCartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
    }
    
    override func configure(productInfo: ProductInfo) {
        let formatter = CurrencyFormatter()
        formatter.minimumFractionDigits = 2
        
        if Double(productInfo.price) > 50 {
            priceLabel.text = "\(formatter.beautify(Double(productInfo.price))) RUB" }
        else {
            priceLabel.text = "цена по запросу"
        }
        if productInfo.article == "" {
            articleLabel.text = "арт. -"
        } else {
            articleLabel.text = "арт." + productInfo.article
        }
        toCartButton.productID = productInfo.id
    }
    
    @objc private func addToCartHandler() {
        performAnimation()
    }
    
    private func performAnimation() {
        let label = getLabelForAddToCartAction()
        animateLabelAndRemove(label)
    }
    
    private func getLabelForAddToCartAction() -> UILabel {
        let label = UILabel()
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: toCartButton.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: toCartButton.centerYAnchor).isActive = true
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.text = "+1"
        return label
    }
    
    private func animateLabelAndRemove(_ label: UILabel) {
        UIView.animate(withDuration: 0.7, animations: {
            label.transform = CGAffineTransform(translationX: 0, y: -200)
            label.layer.opacity = 0.0
        }) { _ in
            label.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}
