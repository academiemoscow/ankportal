//
//  EducationDetailedInfoController.swift
//  ankportal
//
//  Created by Олег Рачков on 19/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

struct EducationDetailedInfo {
    let id: String
    let name: String
    var date: String
    let town: String
    let detailedText: String
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
    let type: [String]

    init(json: [String: Any]) {
        doctorInfo = DoctorInfo(json: ["ID": "", "LAST_NAME": "", "NAME": "", "SECOND_NAME": "", "WORK_POSITION": "", "WORK_PROFILE": "", "PHOTO": ""])
        id = json["ID"] as? String ?? ""
        name = json["NAME"] as? String ?? ""
        date = json["DATE_START"] as? String ?? ""
        town = json["TOWN"] as? String ?? ""
        detailedText = json["DETAIL_TEXT"] as? String ?? ""
        let trainers = json["INSTRUCTORS"] as! NSArray
        if trainers.count > 0 {
            let trainer = trainers[0]
            doctorInfo = DoctorInfo(json: trainer as! [String : Any])
        }
        type = json["TYPE"] as? [String] ?? []
    }
}


class EducationDetailedInfoController: UIViewController {
    var educationId: String?
    var educationName: String?
    var educationCity: String?
    var educationDate: String?
    var doctorName: String?
    var doctorPhoto: UIImage?
    var doctorPhotoURL: String?
    var doctorRegaly: String?
    var educationDetailedText: String?
    
    var educationNameLabel: UILabel = {
        var educationNameLabel = UILabel()
        educationNameLabel.font = UIFont.defaultFont(ofSize: 14)
        educationNameLabel.numberOfLines = 5
        educationNameLabel.backgroundColor = UIColor.ankPurple
        educationNameLabel.textColor = UIColor.black
        educationNameLabel.textAlignment = NSTextAlignment.left
        educationNameLabel.sizeToFit()
        educationNameLabel.layer.masksToBounds = true
        educationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationNameLabel
    }()
    
    var educationCityTextLabel: UILabel = {
        var educationCityTextLabel = UILabel()
        educationCityTextLabel.font = UIFont.defaultFont(ofSize: 14)
        educationCityTextLabel.numberOfLines = 1
        educationCityTextLabel.textAlignment = NSTextAlignment.right
        educationCityTextLabel.sizeToFit()
        educationCityTextLabel.backgroundColor = UIColor.backgroundColor
        educationCityTextLabel.layer.masksToBounds = true
        educationCityTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationCityTextLabel
    }()
    
    var educationDateTextLabel: UILabel = {
        var educationDateTextLabel = UILabel()
        educationDateTextLabel.font = UIFont.defaultFont(ofSize: 14)
        educationDateTextLabel.numberOfLines = 1
        educationDateTextLabel.textAlignment = NSTextAlignment.left
        educationDateTextLabel.backgroundColor = UIColor.backgroundColor
        educationDateTextLabel.sizeToFit()
        educationDateTextLabel.layer.masksToBounds = true
        educationDateTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationDateTextLabel
    }()
    
    var educationNameTextLabel: UILabel = {
        var educationNameTextLabel = UILabel()
        educationNameTextLabel.font = UIFont.defaultFont(ofSize: 14)
        educationNameTextLabel.numberOfLines = 5
        educationNameTextLabel.backgroundColor =  UIColor.ankPurple
        educationNameTextLabel.textColor = UIColor.black
//        educationNameTextLabel.layer.cornerRadius = 37
        educationNameTextLabel.textAlignment = NSTextAlignment.center
        educationNameTextLabel.sizeToFit()
        educationNameTextLabel.layer.masksToBounds = true
        educationNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationNameTextLabel
    }()
    
    lazy var registrationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 10
        button.setTitle("Записаться", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleRegister(){
        let vibrationGenerator = UIImpactFeedbackGenerator()
        vibrationGenerator.impactOccurred()
        let educationRegistrationController = EducationRegistrationViewController()
        educationRegistrationController.educationName = educationNameTextLabel.text
        educationRegistrationController.educationCity = educationCityTextLabel.text
        educationRegistrationController.educationDate = educationDate
        educationRegistrationController.doctorName = educationDoctorNameLabel.text
        educationRegistrationController.doctorPhoto = photoImageView.image
        educationRegistrationController.doctorRegaly = educationDoctorRegalyLabel.text
        educationRegistrationController.educationId = educationId
        educationRegistrationController.title = "Запись"
        firstPageController?.navigationController?.present(educationRegistrationController, animated: true)
    }
    
    let educationPMLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)
        label.textAlignment = NSTextAlignment.left
        label.text = "Программа:"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let photoImageView: ImageLoader = {
        let photo = ImageLoader()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.image = UIImage(named: "doctor")
        photo.layer.cornerRadius = 10
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    let educationDoctorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationDoctorRegalyLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.defaultFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.backgroundColor = UIColor.backgroundColor
        label.isEditable = false
        label.isScrollEnabled = false
        label.isSelectable = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationDetailedTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.defaultFont(ofSize: 14)
        textView.backgroundColor = UIColor.backgroundColor
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let educationDetailedTextPlaceholderView: UIImageView = {
        let newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.image = UIImage(named: "educationText_placeholder")
        newsImageView.backgroundColor = UIColor.backgroundColor
        return newsImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = UIColor.backgroundColor
        self.title = "Семинар"
        
        view.addSubview(educationNameLabel)
        educationNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.midY)!/2-10).isActive = true
        educationNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        educationNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        educationNameLabel.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        educationNameLabel.addSubview(educationNameTextLabel)
        educationNameTextLabel.bottomAnchor.constraint(equalTo: educationNameLabel.bottomAnchor).isActive = true
        educationNameTextLabel.widthAnchor.constraint(equalTo: educationNameLabel.widthAnchor, constant: -10).isActive = true
        educationNameTextLabel.heightAnchor.constraint(equalTo: educationNameLabel.heightAnchor, multiplier: 0.5).isActive = true
        educationNameTextLabel.centerXAnchor.constraint(equalTo: educationNameLabel.centerXAnchor).isActive = true
        
        view.addSubview(educationDateTextLabel)
        educationDateTextLabel.topAnchor.constraint(equalTo: educationNameLabel.bottomAnchor, constant: 10).isActive = true
        educationDateTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        educationDateTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        educationDateTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        
        view.addSubview(photoImageView)
        photoImageView.image = doctorPhoto
        let widthAndHeightPhoto: CGFloat = 100
        photoImageView.leftAnchor.constraint(equalTo: educationDateTextLabel.leftAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: educationDateTextLabel.bottomAnchor, constant: 4).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: widthAndHeightPhoto).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: widthAndHeightPhoto).isActive = true
 
        
        view.addSubview(educationDoctorNameLabel)
        educationDoctorNameLabel.text = doctorName
        educationDoctorNameLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 4).isActive = true
        educationDoctorNameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor).isActive = true
        educationDoctorNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        educationDoctorNameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true

        view.addSubview(educationCityTextLabel)
        educationCityTextLabel.topAnchor.constraint(equalTo: educationDateTextLabel.topAnchor).isActive = true
        educationCityTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        educationCityTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        educationCityTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        view.addSubview(educationDoctorRegalyLabel)
        educationDoctorRegalyLabel.text = doctorRegaly
        educationDoctorRegalyLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 4).isActive = true
        educationDoctorRegalyLabel.topAnchor.constraint(equalTo: educationDoctorNameLabel.bottomAnchor).isActive = true
        educationDoctorRegalyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        educationDoctorRegalyLabel.heightAnchor.constraint(equalToConstant: widthAndHeightPhoto - 25).isActive = true
        
        view.addSubview(registrationButton)
        registrationButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10).isActive = true
        registrationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 60 - contentInsetLeftAndRight*2).isActive = true
        registrationButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
       
        view.addSubview(educationPMLabel)
        educationPMLabel.leftAnchor.constraint(equalTo: photoImageView.leftAnchor).isActive = true
        educationPMLabel.centerYAnchor.constraint(equalTo: registrationButton.centerYAnchor).isActive = true
        educationPMLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        educationPMLabel.heightAnchor.constraint(equalToConstant: 60 - contentInsetLeftAndRight*2).isActive = true
        
        view.addSubview(educationDetailedTextView)
        educationDetailedTextView.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 10).isActive = true
        educationDetailedTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        educationDetailedTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        educationDetailedTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        view.addSubview(educationDetailedTextPlaceholderView)
        educationDetailedTextPlaceholderView.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 10).isActive = true
        educationDetailedTextPlaceholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        educationDetailedTextPlaceholderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        educationDetailedTextPlaceholderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        retrieveEducationsDetailedInfo()
    }
    
    func retrieveEducationsDetailedInfo() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let jsonUrlString = "https://ankportal.ru/rest/index2.php?get=seminardetail&id=" + educationId!
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        if self != nil {
                            let education = EducationDetailedInfo(json: jsonObj)
                            self!.educationDetailedText = education.detailedText
                            self!.educationDate = education.date
                            self!.educationName = education.name
                            self!.doctorPhotoURL = education.doctorInfo.photoURL
                            self!.doctorName = education.doctorInfo.doctorLastName + " " + education.doctorInfo.doctorName
                            self!.doctorRegaly = education.doctorInfo.workProfile
                            
                        }
                    }
                    DispatchQueue.main.async {
                        if self != nil {
                            self!.educationDetailedTextPlaceholderView.isHidden = true
                            self!.educationDetailedTextView.text = self!.educationDetailedText?.htmlToString
                            if self!.doctorPhotoURL != "" {
                                self!.photoImageView.loadImageWithUrl(URL(string: self!.doctorPhotoURL!)!)
                            }
                            self!.educationDoctorNameLabel.text = self!.doctorName
                            self!.educationDoctorRegalyLabel.text = self!.doctorRegaly?.htmlToString
                            self?.title = self!.educationDate
                            self?.educationNameTextLabel.text = self!.educationName
                        }
                    }
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
    
    
}
