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
    var navigationControllerHeight: CGFloat = 0
    
    var educationId: String?
    var educationName: String?
    var educationCity: String?
    var educationDate: String?
    var doctorName: String?
    var doctorPhoto: UIImage?
    var doctorRegaly: String?
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.tintColor = UIColor.black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let educationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(ofSize: 14)//(ofSize: 14)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.right
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let educationInfoTextLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.defaultFont(ofSize: 12)
        textView.isEditable = false
        textView.textAlignment = NSTextAlignment.left
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(white: 1, alpha: 0)
        textView.text = ""
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let educationZPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(ofSize: 14)
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
        label.font = UIFont.defaultFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationDoctorRegalyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    lazy var showMoreInfoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = lightFirmColor
//        button.setTitle("подробнее", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.layer.cornerRadius = 10
//        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(showDetailedInfoController), for: .touchUpInside)
//        return button
//    }()
    
    lazy var showMoreInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.setTitle("ПОДРОБНЕЕ", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(ofSize: 14)
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.titleLabel?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.titleLabel?.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
        button.titleLabel?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "readmore"), for: .normal)
        
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.imageView?.rightAnchor.constraint(equalTo: button.titleLabel!.leftAnchor).isActive = true
        button.imageView?.centerYAnchor.constraint(equalTo: button.titleLabel!.centerYAnchor).isActive = true
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.imageView?.frame.size.width = 20
        button.imageView?.bounds.size.width = 20
        
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showDetailedInfoController), for: .touchUpInside)
        
        return button
    }()
    
    @objc func showDetailedInfoController() {
        let educationDetailedInfoController = EducationDetailedInfoController()
        educationDetailedInfoController.educationId = educationId
        educationDetailedInfoController.educationNameTextLabel.text = self.educationInfoTextLabel.text
        educationDetailedInfoController.educationCityTextLabel.text = educationCityLabel.text
        educationDetailedInfoController.educationDateTextLabel.text = educationDateLabel.text
        educationDetailedInfoController.doctorName = educationDoctorNameLabel.text
        educationDetailedInfoController.doctorPhoto = photoImageView.image
        educationDetailedInfoController.doctorRegaly = educationDoctorRegalyLabel.text
        firstPageController?.navigationController?.pushViewController(educationDetailedInfoController, animated: true)
    }
    

    lazy var registrationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.setTitle("ЗАПИСАТЬСЯ", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(ofSize: 14)
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.titleLabel?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.titleLabel?.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
        button.titleLabel?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pencil"), for: .normal)
        
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.imageView?.rightAnchor.constraint(equalTo: button.titleLabel!.leftAnchor).isActive = true
        button.imageView?.centerYAnchor.constraint(equalTo: button.titleLabel!.centerYAnchor).isActive = true
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.imageView?.frame.size.width = 20
        button.imageView?.bounds.size.width = 20
        
        
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleRegister(){
        let vibrationGenerator = UIImpactFeedbackGenerator()
        vibrationGenerator.impactOccurred()
        let educationRegistrationController = EducationRegistrationViewController()
        educationRegistrationController.educationName = educationInfoTextLabel.text
        educationRegistrationController.educationCity = educationCityLabel.text
        educationRegistrationController.educationDate = educationDateLabel.text
        educationRegistrationController.doctorName = educationDoctorNameLabel.text
        educationRegistrationController.doctorPhoto = photoImageView.image
        educationRegistrationController.doctorRegaly = educationDoctorRegalyLabel.text
        educationRegistrationController.educationId = educationId
        educationRegistrationController.title = "Запись"
        firstPageController?.navigationController?.present(educationRegistrationController, animated: true)
    }
    
    override func prepareForReuse() {
        photoImageView.image = UIImage(named: "doctor")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        let distanceBetweenViews: CGFloat = 3
        
        addSubview(educationDateLabel)
        educationDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        educationDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        educationDateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        educationDateLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let widthFrame = self.frame.size.width * 0.025
        addSubview(educationCityLabel)
        educationCityLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -widthFrame).isActive = true
        educationCityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        educationCityLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        educationCityLabel.heightAnchor.constraint(equalTo: educationDateLabel.heightAnchor).isActive = true
        
        addSubview(educationInfoTextLabel)
        educationInfoTextLabel.leftAnchor.constraint(equalTo: educationDateLabel.leftAnchor).isActive = true
        educationInfoTextLabel.topAnchor.constraint(equalTo: educationDateLabel.bottomAnchor).isActive = true
        educationInfoTextLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthFrame*2).isActive = true
        educationInfoTextLabel.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
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
        educationDoctorNameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor).isActive = true
        educationDoctorNameLabel.widthAnchor.constraint(equalTo: widthAnchor,  constant: -widthFrame*2-widthAndHeightPhoto-5).isActive = true
        educationDoctorNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
       
        addSubview(educationDoctorRegalyLabel)
        educationDoctorRegalyLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: distanceBetweenViews).isActive = true
        educationDoctorRegalyLabel.topAnchor.constraint(equalTo: educationDoctorNameLabel.bottomAnchor).isActive = true
        educationDoctorRegalyLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthFrame*2-widthAndHeightPhoto-distanceBetweenViews).isActive = true
        educationDoctorRegalyLabel.heightAnchor.constraint(equalToConstant: widthAndHeightPhoto - 25).isActive = true
    
        addSubview(showMoreInfoButton)
        showMoreInfoButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        showMoreInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -distanceBetweenViews*2).isActive = true
        showMoreInfoButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        showMoreInfoButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: distanceBetweenViews * 5).isActive = true
        
        addSubview(registrationButton)
        registrationButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        registrationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -distanceBetweenViews*2).isActive = true
        registrationButton.widthAnchor.constraint(equalToConstant: 118).isActive = true
        registrationButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: distanceBetweenViews * 5).isActive = true
        
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
