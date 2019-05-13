//
//  EducationListCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 25/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

var dateFilter: Date = Date()
var cityFilter: String = "Все города"
var typeFilter: String = "Все направления"

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

class EducationListCollectionView: UICollectionView {
    var fullEducationList: [EducationList] = []
    var educationList: [EducationList] = []
    var educationListWithoutDate: [EducationList] = []
    var cityArray: [String] = []
    var typeArray: [String] = []
    var cityFilter: String = "Все города"
    var typeFilter: String = "Все направления"
    var dateFilter: Date = Date()
    var settingsShow = false
    var firstLoadKey = true
    var navigationControllerHeight: CGFloat = 0
    
    let cellId = "educationInfoCellId"
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var showSettingsButton: UIButton = {
        var showSettingsButton = UIButton()
        showSettingsButton.setImage(UIImage(named: "filter_barbutton"), for: .normal)
        showSettingsButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        showSettingsButton.layer.cornerRadius = 23
        let buttonSize:CGFloat = 45
        
        showSettingsButton.layer.frame = CGRect(x: layer.frame.size.width - buttonSize*1.25, y: layer.frame.size.height - buttonSize*3, width: buttonSize, height: buttonSize)
        showSettingsButton.addTarget(self, action: #selector(filter), for: .touchUpInside)
        showSettingsButton.isHidden = true
        return showSettingsButton
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.tintColor = UIColor.black
        return indicator
    }()
    
//    var backgroundView: UIView = {
//        var view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.masksToBounds = true
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        view.isHidden = true
//        return view
//    }()
    
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        retrieveEducationsList()
        addSubview(showSettingsButton)
        
        register(EducationInfoCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        contentInset.top = 6
        backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        layout.scrollDirection = .horizontal
        self.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        self.contentInset.left = 10
        self.contentInset.right = 10
 
        let indicatorSize = 500
        addSubview(activityIndicator)
        activityIndicator.layer.frame = CGRect(x: 110, y: 110, width: indicatorSize, height: indicatorSize)
        activityIndicator.startAnimating()
        
//        view.addSubview(backgroundView)
//        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    @objc func filter(){
        let vibrationGenerator = UIImpactFeedbackGenerator()
        vibrationGenerator.impactOccurred()
        let educationSettingsController = EducationSettingsViewController()
        educationSettingsController.cityArray = cityArray
        educationSettingsController.typeArray = typeArray
        educationSettingsController.parentController = self
        educationSettingsController.fullEducationList = self.fullEducationList
        //self.navigationController?.present(educationSettingsController, animated: true)
        //backgroundView.isHidden = false
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
                    self?.cityArray.insert("Все города", at: 0)
                    self?.typeArray.insert("Все направления", at: 0)
                   // for educationWithoutDate in (self?.educationListWithoutDate)!{
                   //     self?.educationList.insert(educationWithoutDate, at: 0)
                   // }
                    DispatchQueue.main.async {
                        self?.reloadData()
                        self?.showSettingsButton.isHidden = false
                        self?.activityIndicator.stopAnimating()
                    }
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
}

extension EducationListCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.75, height: collectionView.frame.width * 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if educationList.count == 0 && firstLoadKey {return 2} else
        {return self.educationList.count }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if educationList.count == 0 && self.firstLoadKey  {
            let cellEducation = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! EducationInfoCollectionViewCell
            cellEducation.educationDateLabel.text = "Дата"
            cellEducation.educationInfoTextLabel.text = "Название"
            DispatchQueue.main.async {
                cellEducation.activityIndicator.startAnimating()
            }
            return cellEducation
        }
        
        let cellEducation = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! EducationInfoCollectionViewCell
        self.firstLoadKey = false
        
        cellEducation.activityIndicator.stopAnimating()
        cellEducation.educationDateLabel.text = educationList[indexPath.row].date
        cellEducation.educationCityLabel.text = educationList[indexPath.row].town
        cellEducation.educationInfoTextLabel.text = educationList[indexPath.row].name
        cellEducation.educationId = educationList[indexPath.row].id
//        cellEducation.parentViewController = self
        cellEducation.navigationControllerHeight = self.navigationControllerHeight
        
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
