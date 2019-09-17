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
    
    var typesArray: [String]?
    
    enum EducationListToolbarItemType: Int {
        case sortingTypes
        case sortingCities
        case sortingDates
    }
    
    static let height = 50
    
    lazy var filterDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Дата ▾", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(ofSize: 16)
        button.tag = EducationListToolbarItemType.sortingDates.rawValue
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.ballonGrey
        button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var filterTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Направление ▾", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.tag = EducationListToolbarItemType.sortingTypes.rawValue
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.ballonGrey
        button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var filterCityButton: UIButton = {
        let button = UIButtonWithBadge(type: .system)
        button.setTitle("Город ▾", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(ofSize: 16)
        button.tag = EducationListToolbarItemType.sortingCities.rawValue
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.ballonGrey
        button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            filterTypeButton,
            filterCityButton,
            filterDateButton
            ])
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: EducationListToolbar.height))
        setupViews()
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        filterTypeButton.translatesAutoresizingMaskIntoConstraints = false
        filterTypeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = false
        
        filterDateButton.translatesAutoresizingMaskIntoConstraints = false
        filterDateButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = false
        
        filterCityButton.translatesAutoresizingMaskIntoConstraints = false
        filterCityButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = false
    }
    
    @objc private func tapButton(sender: UIControl) {
        delegate?.didTapButton(EducationListToolbarItemType.init(rawValue: sender.tag)!)
    }
    
}

