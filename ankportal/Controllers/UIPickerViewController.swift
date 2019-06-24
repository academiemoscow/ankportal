//
//  UIPickerViewController.swift
//  ankportal
//
//  Created by Admin on 21/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UIPickerViewController: UIViewController {
    
    var pickerViewStrings: [String] = [
        "По умолчанию",
        "По цене"
    ]
    
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
    }
    
    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
    }

}

extension UIPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
    }
}
