//
//  CitiesPickerViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 12/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UIEducationCitiesPickerViewController: UIViewController {
    
    var pickerViewStrings: [String] = []
    var parentTableView: EducationsTableViewController?

    private var selectedIndex: Int = 0
    
    lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy var containerView: ShadowView = {
        let view = ShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 50
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        view.addSubview(containerView)
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        containerView.addSubview(pickerView)
        pickerView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
        
        var indexForSelect: Int = 0
        if parentTableView!.cityFilter != "" {
            indexForSelect = (parentTableView?.filteredCitiesArray.index(of: parentTableView!.cityFilter))!
        }
        pickerView.selectRow(indexForSelect, inComponent: 0, animated: true)
    }
    
    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension UIEducationCitiesPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewStrings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewStrings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        
        let selectedCity: String = (parentTableView?.filteredCitiesArray[selectedIndex])!
        
        parentTableView?.cityFilter = selectedCity
        var selectedType = parentTableView?.typeFilter
        var selectedDate = parentTableView?.dateFilter
        
        if selectedType == "" { selectedType = "Все направления" }
        if selectedDate == "" { selectedDate = "Все даты"}
        
        let data = parentTableView?.data
        
        if selectedCity == "Все города" {
            parentTableView?.tableHeaderView.filterCityButton.setTitle("Город ▾", for: .normal)
        } else {
            parentTableView?.tableHeaderView.filterCityButton.setTitle(selectedCity + " ▾", for: .normal)
        }
        
        parentTableView?.filteredData = []
        
        for education in data! {
            if education.type!.count > 0 {
                if education.type![0] != selectedType && selectedType != "Все направления" {
                    continue
                }
            }
            if education.date != selectedDate && selectedDate != "Все даты" {
                continue
            }
            
            if education.town != selectedCity && selectedCity != "Все города" {
                continue
            }
            
            parentTableView?.filteredData.append(education)
        }
        
        parentTableView?.tableView.reloadData()
    }
}
