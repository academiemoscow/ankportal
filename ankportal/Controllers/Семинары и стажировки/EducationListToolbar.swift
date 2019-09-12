//
//  EducationListToolbar.swift
//  ankportal
//
//  Created by Олег Рачков on 10/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

protocol EducationListToolbarDelegate {
    func didTapButton(_ sender: EducationListToolbar.EducationListToolbarItemType)
}

class EducationListToolbar: UIView {
    
    var delegate: EducationListToolbarDelegate?
    
    enum EducationListToolbarItemType: Int {
        case filter = 1
        case sorting
    }
    
    static let height = 50
    
    lazy private var filterDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Даты ▾", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = EducationListToolbarItemType.sorting.rawValue
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.ballonGrey
        button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var filterTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Направления ▾", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = EducationListToolbarItemType.sorting.rawValue
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.ballonGrey
        button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var filterCityButton: UIButtonWithBadge = {
        let button = UIButtonWithBadge(type: .system)
        button.setTitle("Города ▾", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = EducationListToolbarItemType.filter.rawValue
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.ballonGrey
        button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
        button.setBadge(number: 1)
        return button
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            filterDateButton,
            filterTypeButton,
            filterCityButton
            ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: EducationListToolbar.height))
        setupViews()
    }
    
    public func setBadge(_ badgeNumber: Int) {
        filterCityButton.setBadge(number: badgeNumber)
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc private func tapButton(sender: UIControl) {
        delegate?.didTapButton(EducationListToolbarItemType.init(rawValue: sender.tag)!)
    }
    
}

