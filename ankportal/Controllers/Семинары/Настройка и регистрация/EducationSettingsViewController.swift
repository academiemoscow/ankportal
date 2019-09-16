//
//  EducationSettingsViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 12/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class EducationSettingsViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var fullEducationList: [EducationInfoFromJSON] = []
    var educationList: [EducationInfoFromJSON] = []
    var educationListWithoutDate: [EducationInfoFromJSON] = []
    
    var cityArray: [String] = []
    var typeArray: [String] = []
    
    var parentController: EducationListCollectionView?
    
    let settingsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        return view
    }()
    
    lazy var hideSettingsButton: UIButton = {
        var showSettingsButton = UIButton()
        showSettingsButton.backgroundColor = UIColor.init(white: 1, alpha: 0)
        showSettingsButton.layer.borderColor = UIColor.black.cgColor
        showSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        showSettingsButton.addTarget(self, action: #selector(hideSettings), for: .touchUpInside)
        return showSettingsButton
    }()
    
    lazy var applySettingsButton: UIButton = {
        var applySettingsButton = UIButton()
        applySettingsButton.setImage(UIImage(named: "apply_icon"), for: .normal)
        applySettingsButton.backgroundColor = UIColor.lightGray
        applySettingsButton.layer.cornerRadius = 22
        let buttonSize:CGFloat = 45
        applySettingsButton.layer.frame = CGRect(x: view.layer.frame.size.width / 2 - buttonSize / 2, y: view.layer.frame.size.height / 2 - buttonSize / 2, width: buttonSize, height: buttonSize)
        applySettingsButton.addTarget(self, action: #selector(hideAndApplySettings), for: .touchUpInside)
        return applySettingsButton
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(dateChange), for: UIControl.Event.valueChanged)
        return datePicker
    }()
    
    @objc func dateChange() {
        dateFilter = datePicker.date
    }
    
    let cityPicker: UIPickerView = {
        let cityPicker = UIPickerView()
        cityPicker.backgroundColor = UIColor.white
        cityPicker.layer.cornerRadius = 15
        cityPicker.translatesAutoresizingMaskIntoConstraints = false
        return cityPicker
    }()
    
    @objc func hideAndApplySettings() {
        let vibrationGenerator = UIImpactFeedbackGenerator()
        vibrationGenerator.impactOccurred()
        
        parentController?.backgroundView?.isHidden = true
        filterDataBySettings()
//        parentController?.educationList = educationList
//        parentController?.cityFilter = cityFilter
//        parentController?.typeFilter = typeFilter
//        parentController?.dateFilter = dateFilter
        
//        parentController?.collectionView.reloadData()
//        if educationList.count>0 {
//            parentController?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func hideSettings() {
        let vibrationGenerator = UIImpactFeedbackGenerator()
        vibrationGenerator.impactOccurred()
        parentController?.backgroundView?.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func filterDataBySettings(){
        var filteredEducationList: [EducationInfoFromJSON] = []
        var isFilterred: Bool = true
        cityFilter = cityArray[cityPicker.selectedRow(inComponent: 0)]
        typeFilter = typeArray[cityPicker.selectedRow(inComponent: 1)]
        
        for education in fullEducationList {
            isFilterred = true
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy 00:00:00"
            let currentDate = dateFormatter.date(from: education.date)
            if currentDate != nil {
                if currentDate! < dateFilter.addingTimeInterval(-86400){
                    isFilterred = false
                }
            }
            if isFilterred {
                if cityFilter != "Все города"  {
                    if education.town != cityFilter{
                        isFilterred = false
                    }
                }
            }
            if isFilterred {
                if typeFilter != "Все направления" {
                    var typeKey: Bool = false
                    for type in education.type {
                        if type == typeFilter {
                            typeKey = true
                        }
                    }
                    if !typeKey {isFilterred = false}
                }
            }
            
            if isFilterred {
                filteredEducationList.append(education)
            }
        }
        educationList = filteredEducationList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityPicker.dataSource = self
        cityPicker.delegate = self
        view.backgroundColor = UIColor.init(white: 1, alpha: 0)
        view.addSubview(settingsContainerView)
        settingsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        settingsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        settingsContainerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        settingsContainerView.addSubview(hideSettingsButton)
        hideSettingsButton.centerXAnchor.constraint(equalTo: settingsContainerView.centerXAnchor).isActive = true
        hideSettingsButton.topAnchor.constraint(equalTo: settingsContainerView.topAnchor).isActive = true
        hideSettingsButton.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        hideSettingsButton.heightAnchor.constraint(equalTo: settingsContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        settingsContainerView.addSubview(datePicker)
        datePicker.centerXAnchor.constraint(equalTo: settingsContainerView.centerXAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: settingsContainerView.bottomAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalTo: settingsContainerView.heightAnchor, multiplier: 0.25).isActive = true
        
        settingsContainerView.addSubview(cityPicker)
        cityPicker.centerXAnchor.constraint(equalTo: settingsContainerView.centerXAnchor).isActive = true
        cityPicker.topAnchor.constraint(equalTo: hideSettingsButton.bottomAnchor).isActive = true
        cityPicker.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        cityPicker.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: 20).isActive = true
        
        view.addSubview(applySettingsButton)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        datePicker.date = dateFilter
        modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor.init(white: 1, alpha: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension EducationSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0   {return cityArray.count} else {return typeArray.count}
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0   {return view.frame.size.width*0.35} else {return view.frame.size.width*0.65}
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let text:String = { if component == 0   {return cityArray[row]} else {return typeArray[row]}}()
        
        if component == 0 && cityFilter == cityArray[row]{
            cityPicker.selectRow(row, inComponent: 0, animated: false)
        }
        if component == 1 && typeFilter == typeArray[row] {
            cityPicker.selectRow(row, inComponent: 1, animated: false)
        }
        pickerLabel.text = text
        pickerLabel.font = UIFont.systemFont(ofSize: 16)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 { cityFilter = cityArray[row]} else {typeFilter = typeArray[row]}
    }
    
}
