//
//  EducationInfoCollectionViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 25/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class EducationInfoCollectionViewCell: UICollectionViewCell {
    
    var parentViewController: UIViewController?
    
    let educationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.right
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let educationInfoTextLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.textAlignment = NSTextAlignment.left
        textView.isScrollEnabled = false
        textView.text = ""
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let educationZPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        label.text = "Занятия проведёт"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.image = UIImage(named: "doctor")
        photo.layer.cornerRadius = 20
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    let educationDoctorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationDoctorRegalyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let showMoreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.setTitle("ПОДРОБНЕЕ", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
//                button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.setTitle("ЗАПИСАТЬСЯ", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRegister(){
        let educationRegistrationController = EducationRegistrationViewController()
        educationRegistrationController.educationName = educationInfoTextLabel.text
        educationRegistrationController.educationCity = educationCityLabel.text
        educationRegistrationController.educationDate = educationDateLabel.text
        educationRegistrationController.doctorName = educationDoctorNameLabel.text
        educationRegistrationController.doctorPhoto = photoImageView.image
        educationRegistrationController.doctorRegaly = educationDoctorRegalyLabel.text
        educationRegistrationController.title = "Запись"
        parentViewController?.navigationController?.present(educationRegistrationController, animated: true)
    }
    
    override func prepareForReuse() {
        photoImageView.image = UIImage(named: "doctor")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 4
        let distanceBetweenViews: CGFloat = 3
        
        addSubview(educationDateLabel)
        educationDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        educationDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        educationDateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        educationDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let widthFrame = self.frame.size.width * 0.025
        addSubview(educationCityLabel)
        educationCityLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -widthFrame).isActive = true
        educationCityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        educationCityLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        educationCityLabel.heightAnchor.constraint(equalTo: educationDateLabel.heightAnchor).isActive = true
        
        addSubview(educationInfoTextLabel)
        educationInfoTextLabel.leftAnchor.constraint(equalTo: educationDateLabel.leftAnchor).isActive = true
        educationInfoTextLabel.topAnchor.constraint(equalTo: educationDateLabel.bottomAnchor, constant: distanceBetweenViews).isActive = true
        educationInfoTextLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthFrame*2).isActive = true
        educationInfoTextLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        
        addSubview(educationZPLabel)
        educationZPLabel.leftAnchor.constraint(equalTo: educationDateLabel.leftAnchor).isActive = true
        educationZPLabel.topAnchor.constraint(equalTo: educationInfoTextLabel.bottomAnchor, constant: distanceBetweenViews).isActive = true
        educationZPLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        educationZPLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(photoImageView)
        let widthAndHeightPhoto = self.frame.size.width * 0.25
        photoImageView.leftAnchor.constraint(equalTo: educationDateLabel.leftAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: educationZPLabel.bottomAnchor, constant: distanceBetweenViews).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: widthAndHeightPhoto).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: widthAndHeightPhoto).isActive = true
        
        addSubview(educationDoctorNameLabel)
        educationDoctorNameLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: distanceBetweenViews).isActive = true
        educationDoctorNameLabel.topAnchor.constraint(equalTo: educationZPLabel.bottomAnchor, constant: distanceBetweenViews).isActive = true
        educationDoctorNameLabel.widthAnchor.constraint(equalTo: widthAnchor,  constant: -widthFrame*2-widthAndHeightPhoto-5).isActive = true
        educationDoctorNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
       
        addSubview(educationDoctorRegalyLabel)
        educationDoctorRegalyLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: distanceBetweenViews).isActive = true
        educationDoctorRegalyLabel.topAnchor.constraint(equalTo: educationDoctorNameLabel.bottomAnchor).isActive = true
        educationDoctorRegalyLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthFrame*2-widthAndHeightPhoto-distanceBetweenViews).isActive = true
        educationDoctorRegalyLabel.heightAnchor.constraint(equalToConstant: widthAndHeightPhoto - 25).isActive = true
        
        addSubview(showMoreInfoButton)
        let widthButton = frame.size.width*0.5 - widthFrame
        showMoreInfoButton.leftAnchor.constraint(equalTo: leftAnchor, constant: distanceBetweenViews*2).isActive = true
        showMoreInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -distanceBetweenViews*2).isActive = true
        showMoreInfoButton.widthAnchor.constraint(equalToConstant: widthButton).isActive = true
        showMoreInfoButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: distanceBetweenViews).isActive = true
        
        addSubview(registrationButton)
        registrationButton.leftAnchor.constraint(equalTo: showMoreInfoButton.rightAnchor, constant: distanceBetweenViews).isActive = true
        registrationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -distanceBetweenViews*2).isActive = true
        registrationButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -distanceBetweenViews*2).isActive = true
        registrationButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: distanceBetweenViews).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
