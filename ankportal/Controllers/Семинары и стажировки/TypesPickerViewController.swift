//
//  TypesPickerViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 12/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UIEducationTypesPickerViewController: UIViewController {
    
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
        
        var indexForSelect: Int = 0
        if parentTableView!.typeFilter != "" {
             indexForSelect = (parentTableView?.filteredTypesArray.index(of: parentTableView!.typeFilter))!
        }
        pickerView.selectRow(indexForSelect, inComponent: 0, animated: true)
    
    }
    
    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension UIEducationTypesPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        
        let selectedType: String = (parentTableView?.typesArray[selectedIndex])!
       
        parentTableView?.typeFilter = selectedType
        var selectedDate = parentTableView?.dateFilter
        var selectedCity = parentTableView?.cityFilter
       
        if selectedDate == "" { selectedDate = "Все даты" }
        if selectedCity == "" { selectedCity = "Все города"}
        
        let data = parentTableView?.data
        
        if selectedType == "Все направления" {
            parentTableView?.tableHeaderView.filterTypeButton.setTitle("Направление ▾", for: .normal)
        } else {
            parentTableView?.tableHeaderView.filterTypeButton.setTitle(selectedType + " ▾", for: .normal)
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
        
            let filteredData = parentTableView?.data

            parentTableView?.filteredDatesArray = []
            for education in filteredData! {
                if education.type!.count > 0 {
                if !(parentTableView?.filteredDatesArray.contains(education.date!))! && (education.type![0] == selectedType || selectedType == "Все направления") {
                    parentTableView?.filteredDatesArray.append(education.date!)
                }
        }
            }
            parentTableView?.filteredDatesArray.sort()
            parentTableView?.filteredDatesArray.insert("Все даты", at: 0)
        
            parentTableView?.tableView.reloadData()
    }
    
    
}

