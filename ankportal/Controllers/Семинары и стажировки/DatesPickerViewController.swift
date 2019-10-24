//
//  DatesPickerViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 12/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UIEducationDatesPickerViewController: UIViewController {
    
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
        if parentTableView!.dateFilter != "" {
            indexForSelect = (parentTableView?.filteredDatesArray.index(of: parentTableView!.dateFilter))!
        }
        pickerView.selectRow(indexForSelect, inComponent: 0, animated: true)
        
    }
    
    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension UIEducationDatesPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        
        let selectedDate: String = (parentTableView?.filteredDatesArray[selectedIndex])!
        
        parentTableView?.dateFilter = selectedDate
        var selectedType = parentTableView?.typeFilter
        var selectedCity = parentTableView?.cityFilter
        
        if selectedType == "" { selectedType = "Все направления" }
        if selectedCity == "" { selectedCity = "Все города"}
        
        let data = parentTableView?.data
        
        if selectedDate == "Все даты" {
            parentTableView?.tableHeaderView.filterDateButton.setTitle("Дата ▾", for: .normal)
        } else {
            let dateSubString = selectedDate.split(separator: ".")
            parentTableView?.tableHeaderView.filterDateButton.setTitle(dateSubString[0] + "." + dateSubString[1] + " ▾", for: .normal)
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

