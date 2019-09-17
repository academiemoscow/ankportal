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

struct EducationInfoFromJSON {
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

class EducationInfo {
    var educationInfoFromJSON: EducationInfoFromJSON!
    enum CellSide {
        case name
        case trainer
    }
    var side: CellSide = .name
}

class EducationListCollectionView_old: UICollectionViewInTableViewCell {
    var fullEducationList: [EducationInfoFromJSON] = []
    var educationList: [EducationInfoFromJSON] = []
    var educationCellArray: [EducationInfo] = []
    var educationListWithoutDate: [EducationInfoFromJSON] = []
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
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        retrieveEducationsList()
        addSubview(showSettingsButton)
        
        register(EducationInfoCollectionViewCell_old.self, forCellWithReuseIdentifier: self.cellId)
        contentInset.top = 6
        backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        layout.scrollDirection = .horizontal
        self.backgroundColor = UIColor.backgroundColor
        self.contentInset.left = contentInsetLeftAndRight
        self.contentInset.right = contentInsetLeftAndRight
        contentInset.top = contentInsetLeftAndRight
        self.contentInset.bottom = contentInsetLeftAndRight
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        let indicatorSize = 500
        addSubview(activityIndicator)
        activityIndicator.layer.frame = CGRect(x: 110, y: 110, width: indicatorSize, height: indicatorSize)
        activityIndicator.startAnimating()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var dataIsEmpty: Bool {
        get {
            return educationList.isEmpty
        }
    }
    
    @objc func filter(){
        let vibrationGenerator = UIImpactFeedbackGenerator()
        vibrationGenerator.impactOccurred()
        let educationSettingsController = EducationSettingsViewController()
        educationSettingsController.cityArray = cityArray
        educationSettingsController.typeArray = typeArray
//        educationSettingsController.parentController = self
        educationSettingsController.fullEducationList = self.fullEducationList
    }
    
    func retrieveEducationsList() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy"
//        let currentDate = dateFormatter.date(from: dateFormatter.string(from: NSDate() as Date))
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=seminarlist&f_>PROPERTY_DATE_START=today"
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        let education = EducationInfoFromJSON(json: jsonObj)
                        if self?.cityArray.firstIndex(of: education.town) == nil {
                            self?.cityArray.append(education.town)
                        }
                        for types in education.type {
                            if self?.typeArray.firstIndex(of: types) == nil {
                                self?.typeArray.append(types)
                            }
                        }
                        self?.educationList.append(education)
//                        let dateOfEducation = dateFormatter.date(from: education.date)
//                        if dateOfEducation != nil {
//                            let timeDif = Double((currentDate?.timeIntervalSince(dateOfEducation!))!)
//                            if timeDif <= 0 {
//                                self?.educationList.append(education)
//                            }
//                        } else if education.date == "" {
//                            education.date = "Открытая дата"
//                            self?.educationListWithoutDate.append(education)
//                        }
                    }
                    
//                    let sortedArray = self?.educationList.sorted(by: { (lhs, rhs) -> Bool in
//                        return Float((dateFormatter.date(from: lhs.date)?.timeIntervalSince1970)!) < Float((dateFormatter.date(from: rhs.date)?.timeIntervalSince1970)!)
//                    })
//                    self?.educationList = sortedArray!
//                    for education in sortedArray! {
//                        let educationCell = EducationInfo()
//                        educationCell.educationInfoFromJSON = education
//                        self?.educationCellArray.append(educationCell)
//                    }
                    self?.fullEducationList = self!.educationList
                    self?.cityArray.insert("Все города", at: 0)
                    self?.typeArray.insert("Все направления", at: 0)
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
    
    override func fetchData() {
        fullEducationList = []
        educationList = []
        educationListWithoutDate = []
        cityArray = []
        typeArray = []
        cityFilter = "Все города"
        typeFilter = "Все направления"
        dateFilter = Date()
        settingsShow = false
        firstLoadKey = true
        
        retrieveEducationsList()
    }
}

extension EducationListCollectionView_old: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9 - contentInsetLeftAndRight, height: collectionView.frame.height - contentInsetLeftAndRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.educationCellArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellEducation = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! EducationInfoCollectionViewCell_old
        cellEducation.educationInfo = educationCellArray[indexPath.row]
        cellEducation.fillCellData()
        return cellEducation
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellEducation = collectionView.cellForItem(at: indexPath) as! EducationInfoCollectionViewCell_old
        
        let detailedInfoViewController = EducationDetailedInfoController()
        detailedInfoViewController.educationId = cellEducation.educationId
        firstPageController?.navigationController?.pushViewController(detailedInfoViewController, animated: true)
        
    }
    
}
