//
//  ProductListToolbar.swift
//  ankportal
//
//  Created by Admin on 21/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

protocol ProductListToolbarDelegate {
    func didTapButton(_ sender: ProductListToolbar.ProductListToolbarItemType)
}

class ProductListToolbar: UIView {
    
    var delegate: ProductListToolbarDelegate?
    
    enum ProductListToolbarItemType: Int {
        case filter = 1
        case sorting
    }
    
    static let height = 50
    
    lazy private var filterButton: UIButtonWithBadge = {
        let button = UIButtonWithBadge(type: .system)
        button.setTitle("Фильтр", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = ProductListToolbarItemType.filter.rawValue
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.ballonGrey
        button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
        button.setBadge(number: 1)
        return button
    }()
    
    lazy private var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сортировка", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = ProductListToolbarItemType.sorting.rawValue
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.ballonGrey
        button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sortButton,
            filterButton
            ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: ProductListToolbar.height))
        setupViews()
    }
    
    public func setBadge(_ badgeNumber: Int) {
        filterButton.setBadge(number: badgeNumber)
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    @objc private func tapButton(sender: UIControl) {
        delegate?.didTapButton(ProductListToolbarItemType.init(rawValue: sender.tag)!)
    }
    
}
