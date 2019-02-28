//
//  EducationListCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 25/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

struct EducationList {
    let id: String
    let name: String
    var date: String
    let town: String
    let time: String
    let type: [String]
    var doctorInfo: DoctorInfo
    
    struct DoctorInfo {
        let id: String
        let doctorLastName: String
        var doctorName: String
        let doctorSecondName: String
        let workPosition: String
        let workProfile: String
        let photoURL: String
        init(json: [String: Any]) {
            id = json["ID"] as? String ?? ""
            doctorLastName = json["LAST_NAME"] as? String ?? ""
            doctorName = json["NAME"] as? String ?? ""
            doctorSecondName = json["SECOND_NAME"] as? String ?? ""
            workPosition = json["WORK_POSITION"] as? String ?? ""
            workProfile = json["WORK_PROFILE"] as? String ?? ""
            photoURL = json["PHOTO"] as? String ?? ""
        }
    }
 
    init(json: [String: Any]) {
        doctorInfo = DoctorInfo(json: ["ID": "", "LAST_NAME": "", "NAME": "", "SECOND_NAME": "", "WORK_POSITION": "", "WORK_PROFILE": "", "PHOTO": ""])
       // print(json["TRAINERS"])
        id = json["ID"] as? String ?? ""
        name = json["NAME"] as? String ?? ""
        date = json["DATE_START"] as? String ?? ""
        town = json["TOWN"] as? String ?? ""
        time = json["TIME"] as? String ?? ""
        type = json["TYPE"] as? [String] ?? []
        let trainers = json["TRAINERS"] as! NSArray
        if trainers.count > 0 {
            doctorInfo = DoctorInfo(json: trainers[0] as! [String : Any])
        }
    }
}

class EducationListCollectionView: UICollectionViewController {
    var fullEducationList: [EducationList] = []
    var educationList: [EducationList] = []
    var educationListWithoutDate: [EducationList] = []
    var cityArray: [String] = []
    var typeArray: [String] = []
    var settingsShow = false
    private let cellId = "educationInfoCellId"
    
    let layout = UICollectionViewFlowLayout()
    
    let settingsContainerView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(dateChange), for: UIControl.Event.valueChanged)
        return datePicker
    }()
    
    let cityPicker: UIPickerView = {
        let cityPicker = UIPickerView()
        cityPicker.translatesAutoresizingMaskIntoConstraints = false
        return cityPicker
    }()
    
    @objc func dateChange() {
        educationList = fullEducationList
        var filteredEducationList: [EducationList] = []
        print(datePicker.date)
        for education in educationList {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy 00:00:00"
            let currentDate = dateFormatter.date(from: education.date)
            if currentDate != nil {
                if currentDate! >= datePicker.date.addingTimeInterval(-86400){
                    filteredEducationList.append(education)
                }
            }
        }
        educationList = filteredEducationList
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityPicker.dataSource = self
        cityPicker.delegate = self
        
        view.addSubview(settingsContainerView)
        settingsContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.maxY)!).isActive = true
        settingsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        settingsContainerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        settingsContainerView.isHidden = !settingsShow
        
        settingsContainerView.addSubview(datePicker)
        datePicker.centerXAnchor.constraint(equalTo: settingsContainerView.centerXAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: settingsContainerView.bottomAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalTo: settingsContainerView.heightAnchor, multiplier: 0.5).isActive = true

        retrieveEducationsList()
        
        settingsContainerView.addSubview(cityPicker)
        cityPicker.topAnchor.constraint(equalTo: settingsContainerView.topAnchor).isActive = true
        cityPicker.bottomAnchor.constraint(equalTo: datePicker.topAnchor).isActive = true
        cityPicker.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        cityPicker.centerXAnchor.constraint(equalTo: settingsContainerView.centerXAnchor).isActive = true
        
        self.collectionView.register(EducationInfoCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter_barbutton"), style: .plain, target: self, action: #selector(filter))
        self.navigationItem.title = "Семинары и стажировки"
    }
    
    @objc func filter(){
        settingsShow = !settingsShow
        settingsContainerView.isHidden = !settingsShow
        if settingsShow {
            collectionView.frame.origin.y = view.frame.midY
        } else {
            collectionView.frame.origin.y = view.frame.minY
        }
        self.collectionView.reloadData()
    }
    
    func retrieveEducationsList() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDate = dateFormatter.date(from: dateFormatter.string(from: NSDate() as Date))

        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=seminarlist"
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        var education = EducationList(json: jsonObj)
                        if self?.cityArray.firstIndex(of: education.town) == nil {
                            self?.cityArray.append(education.town)
                        }
                        for types in education.type {
                            if self?.typeArray.firstIndex(of: types) == nil {
                                self?.typeArray.append(types)
                            }
                        }
                        let dateOfEducation = dateFormatter.date(from: education.date)
                        if dateOfEducation != nil {
                            let timeDif = Double((currentDate?.timeIntervalSince(dateOfEducation!))!)
                            if timeDif <= 0 {
                                self?.educationList.append(education)
                 
                            }
                        } else if education.date == "" {
                            education.date = "Открытая дата"
                            self?.educationListWithoutDate.append(education)
                        }
                    }
                    let sortedArray = self?.educationList.sorted(by: { (lhs, rhs) -> Bool in
                        return Float((dateFormatter.date(from: lhs.date)?.timeIntervalSince1970)!) < Float((dateFormatter.date(from: rhs.date)?.timeIntervalSince1970)!)
                    })
                    self?.educationList = sortedArray!
                    self?.fullEducationList = sortedArray!
                    for educationWithoutDate in (self?.educationListWithoutDate)!{
                        self?.educationList.insert(educationWithoutDate, at: 0)
                    }
                    DispatchQueue.main.async {
                         self?.collectionView.reloadData()
                    }
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
        
    }
    
    func dateString(){ //преобразрвание даты в строку
        
    }
    
}

extension EducationListCollectionView: UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0   {return cityArray.count} else {return typeArray.count}
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0   {return view.frame.size.width*0.3} else {return view.frame.size.width*0.7}
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text:String = { if component == 0   {return cityArray[row]} else {return typeArray[row]}}()
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 10)]
        let attributedQuote = NSAttributedString(string: text, attributes: attributes)
        return attributedQuote
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0   {print(cityArray[row])} else {print(typeArray[row])}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: collectionView.frame.width * 0.95)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return educationList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cellEducation = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! EducationInfoCollectionViewCell
        cellEducation.educationDateLabel.text = educationList[indexPath.row].date
        cellEducation.educationCityLabel.text = educationList[indexPath.row].town
        cellEducation.educationInfoTextLabel.text = educationList[indexPath.row].name
        let doctorLastName = educationList[indexPath.row].doctorInfo.doctorLastName
        let doctorName = educationList[indexPath.row].doctorInfo.doctorName
        let educationDoctorRegalyLabel = educationList[indexPath.row].doctorInfo.workProfile
        if doctorName == "" && doctorLastName == "" {
            cellEducation.photoImageView.image = UIImage(named: "doctor")
            imageNewsPhotosCache.setObject("" as AnyObject, forKey: "Тренер не назначен" as AnyObject)
            cellEducation.educationDoctorNameLabel.text = "Тренер не назначен"
            cellEducation.educationDoctorRegalyLabel.text = "информация уточняется"
        } else {
            cellEducation.educationDoctorNameLabel.text = doctorLastName + " " + doctorName
            cellEducation.educationDoctorRegalyLabel.text = educationDoctorRegalyLabel.htmlToString
            let photoURL = educationList[indexPath.row].doctorInfo.photoURL
            if photoURL != "" {
            } else {return cellEducation}
            if let image = imageNewsPhotosCache.object(forKey: photoURL as AnyObject) as! UIImage? {
                cellEducation.photoImageView.image = image
            }
            else if photoURL != "" {
                let url = URL(string: photoURL)!
                URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
                    if data != nil{
                        let image = UIImage(data: data!)
                        imageNewsPhotosCache.setObject(image!, forKey: photoURL as AnyObject)
                        DispatchQueue.main.async {
                            cellEducation.photoImageView.image = image
                        }
                    }
                }).resume()
            }
        }
        return cellEducation
        
        
        
        
    }
}
