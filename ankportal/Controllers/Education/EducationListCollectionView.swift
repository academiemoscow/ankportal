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
    var educationList: [EducationList] = []
    var educationListWithoutDate: [EducationList] = []
    private let cellId = "newsDetailedTextCell"
    
    let layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveNewsList()
        self.collectionView.register(EducationInfoCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.white
        self.navigationItem.title = "Семинары и стажировки"
    }
    
    
    func retrieveNewsList() {
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
    
    func dateString(){ //преобразрвание 
        
    }
    
}

extension EducationListCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: collectionView.frame.width * 0.95)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return educationList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! EducationInfoCollectionViewCell
        cell.educationDateLabel.text = educationList[indexPath.row].date
        cell.educationCityLabel.text = educationList[indexPath.row].town
        cell.educationInfoTextLabel.text = educationList[indexPath.row].name
        let doctorLastName = educationList[indexPath.row].doctorInfo.doctorLastName
        let doctorName = educationList[indexPath.row].doctorInfo.doctorName
        let educationDoctorRegalyLabel = educationList[indexPath.row].doctorInfo.workProfile
        if doctorName == "" && doctorLastName == "" {
            cell.photoImageView.image = UIImage(named: "doctor")
            imageNewsPhotosCache.setObject("" as AnyObject, forKey: "Тренер не назначен" as AnyObject)
            cell.educationDoctorNameLabel.text = "Тренер не назначен"
            cell.educationDoctorRegalyLabel.text = "информация уточняется"
        } else {
            cell.educationDoctorNameLabel.text = doctorLastName + " " + doctorName
            cell.educationDoctorRegalyLabel.text = educationDoctorRegalyLabel.htmlToString
            let photoURL = educationList[indexPath.row].doctorInfo.photoURL
            if photoURL != "" {
            } else {return cell}
            if let image = imageNewsPhotosCache.object(forKey: photoURL as AnyObject) as! UIImage? {
                cell.photoImageView.image = image
            }
            else if photoURL != "" {
                    let url = URL(string: photoURL)!
                    URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
                        if data != nil{
                            let image = UIImage(data: data!)
                            imageNewsPhotosCache.setObject(image!, forKey: photoURL as AnyObject)
                            DispatchQueue.main.async {
                                cell.photoImageView.image = image
                            }
                        }
                    }).resume()
            }
        }
        return cell
    }
}
