//
//  EducationInfoCollectionViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 25/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class EducationInfoCollectionViewCell_old: UICollectionViewCell {
    
    var parentViewController: UIViewController?
    var navigationControllerHeight: CGFloat = 0
    
    var educationId: String?
    var educationName: String?
    var educationCity: String?
    var educationDate: String?
    var doctorName: String?
    var doctorPhoto: UIImage?
    var doctorRegaly: String?
    var educationInfo: EducationInfo?
    
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.tintColor = UIColor.black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let educationInfoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let trainerInfoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let educationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.footnote)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.footnote)
        label.textAlignment = NSTextAlignment.right
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let educationInfoTextLabel: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.callout)
//        textView.isEditable = false
        textView.textAlignment = NSTextAlignment.left
//        textView.isScrollEnabled = false
//        textView.isSelectable = false
        textView.backgroundColor = UIColor(white: 1, alpha: 0)
        textView.text = ""
        textView.isUserInteractionEnabled = true
        textView.numberOfLines = 5
        textView.textAlignment = .natural
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handle))
//        textView.addGestureRecognizer(tap)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
//    @objc func handle() {
//        let detailedInfoViewController = EducationDetailedInfoController()
//        detailedInfoViewController.educationId = self.educationId
//        firstPageController?.navigationController?.pushViewController(detailedInfoViewController, animated: true)
//    }

    let photoImageView: ImageLoader = {
        let photo = ImageLoader()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.layer.cornerRadius = 20
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    let educationDoctorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.callout)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationDoctorRegalyLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.footnote)
        label.textAlignment = NSTextAlignment.left
        label.contentInset.left = 0
        label.isEditable = false
        label.isScrollEnabled = false
        label.isSelectable = false
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var showTrainerInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.setTitle("🔎 ТРЕНЕР", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)
        button.titleLabel?.textAlignment = NSTextAlignment.left
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.titleLabel?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.titleLabel?.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        button.titleLabel?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapForInfoAboutTrainer), for: .touchUpInside)
        
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
        button.setTitle("ЗАПИСАТЬСЯ ✒️", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.titleLabel?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.titleLabel?.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
        button.titleLabel?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    lazy var showEducationInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.setTitle("📆 МЕРОПРИЯТИЕ", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)
        button.titleLabel?.textAlignment = NSTextAlignment.left
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.titleLabel?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.titleLabel?.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        button.titleLabel?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapForInfoAboutEducation), for: .touchUpInside)
        
        return button
    }()
    
    func fillCellData() {
        self.educationId = educationInfo?.educationInfoFromJSON.id
        educationDateLabel.text = educationInfo?.educationInfoFromJSON.date
        educationCityLabel.text = educationInfo?.educationInfoFromJSON.town
        educationInfoTextLabel.text = educationInfo?.educationInfoFromJSON.name
        educationDoctorNameLabel.text = (educationInfo?.educationInfoFromJSON.doctorInfo.doctorLastName)! + " " + (educationInfo?.educationInfoFromJSON.doctorInfo.doctorName)!
        educationDoctorRegalyLabel.text = educationInfo?.educationInfoFromJSON.doctorInfo.workProfile.htmlToString
        
        if educationInfo?.side == .name {
            educationInfoContainerView.isHidden = false
            trainerInfoContainerView.isHidden = true
            if educationDoctorNameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                showTrainerInfoButton.isHidden = true
            } else {
                showTrainerInfoButton.isHidden = false
            }
            setConstraintsForInfoSide()
        } else {
            educationInfoContainerView.isHidden = true
            trainerInfoContainerView.isHidden = false
            setConstraintsForTrainerSide()
        }
    }
    
    func setConstraintsForInfoSide(){
        addSubview(educationInfoContainerView)
        educationInfoContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        educationInfoContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        educationInfoContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        educationInfoContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        educationInfoContainerView.addSubview(educationDateLabel)
        educationDateLabel.leftAnchor.constraint(equalTo: educationInfoContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationDateLabel.topAnchor.constraint(equalTo: educationInfoContainerView.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationDateLabel.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, multiplier: 0.6).isActive = true
        educationDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        educationInfoContainerView.addSubview(educationCityLabel)
        educationCityLabel.rightAnchor.constraint(equalTo: educationInfoContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        educationCityLabel.topAnchor.constraint(equalTo: educationInfoContainerView.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationCityLabel.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, multiplier: 0.4).isActive = true
        educationCityLabel.heightAnchor.constraint(equalTo: educationDateLabel.heightAnchor).isActive = true
        
        educationInfoContainerView.addSubview(educationInfoTextLabel)
        educationInfoTextLabel.leftAnchor.constraint(equalTo: educationInfoContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationInfoTextLabel.topAnchor.constraint(equalTo: educationDateLabel.bottomAnchor).isActive = true
        educationInfoTextLabel.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, constant: -contentInsetLeftAndRight).isActive = true
        educationInfoTextLabel.bottomAnchor.constraint(equalTo: educationInfoContainerView.bottomAnchor, constant: -25).isActive = true
        
        educationInfoContainerView.addSubview(registrationButton)
        registrationButton.rightAnchor.constraint(equalTo: educationInfoContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        registrationButton.bottomAnchor.constraint(equalTo: educationInfoContainerView.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        registrationButton.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, multiplier: 0.65).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        educationInfoContainerView.addSubview(showTrainerInfoButton)
        showTrainerInfoButton.leftAnchor.constraint(equalTo: educationInfoContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        showTrainerInfoButton.bottomAnchor.constraint(equalTo: educationInfoContainerView.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        showTrainerInfoButton.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, multiplier: 0.45).isActive = true
        showTrainerInfoButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    func setConstraintsForTrainerSide() {
        addSubview(trainerInfoContainerView)
        trainerInfoContainerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        trainerInfoContainerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        trainerInfoContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        trainerInfoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        trainerInfoContainerView.addSubview(showEducationInfoButton)
        showEducationInfoButton.leftAnchor.constraint(equalTo: leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        showEducationInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        showEducationInfoButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        showEducationInfoButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        trainerInfoContainerView.addSubview(photoImageView)
        let widthAndHeightPhoto = self.frame.size.width * 0.35
        photoImageView.leftAnchor.constraint(equalTo: trainerInfoContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: showEducationInfoButton.topAnchor, constant: -contentInsetLeftAndRight).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: widthAndHeightPhoto).isActive = true
        photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsetLeftAndRight).isActive = true
        
        trainerInfoContainerView.addSubview(educationDoctorNameLabel)
        educationDoctorNameLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationDoctorNameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor).isActive = true
        educationDoctorNameLabel.rightAnchor.constraint(equalTo: rightAnchor,  constant: -contentInsetLeftAndRight).isActive = true
        educationDoctorNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        trainerInfoContainerView.addSubview(educationDoctorRegalyLabel)
        educationDoctorRegalyLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationDoctorRegalyLabel.topAnchor.constraint(equalTo: educationDoctorNameLabel.bottomAnchor).isActive = true
        educationDoctorRegalyLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        educationDoctorRegalyLabel.bottomAnchor.constraint(equalTo: showEducationInfoButton.topAnchor, constant: -contentInsetLeftAndRight).isActive = true
        
        trainerInfoContainerView.addSubview(registrationButton)
        registrationButton.rightAnchor.constraint(equalTo: trainerInfoContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        registrationButton.bottomAnchor.constraint(equalTo: trainerInfoContainerView.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        registrationButton.widthAnchor.constraint(equalTo: trainerInfoContainerView.widthAnchor, multiplier: 0.45).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
       
        let photoURL = URL(string: (educationInfo?.educationInfoFromJSON.doctorInfo.photoURL)!)
        
        photoImageView.loadImageWithUrl(photoURL!)
        
}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        photoImageView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(tapForInfoAboutEducation)))
        
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @objc fileprivate func tapForInfoAboutTrainer() {
        educationInfo?.side = .trainer
        UIView.transition(from: self.educationInfoContainerView, to: self.trainerInfoContainerView, duration: 0.5, options: [.transitionCurlUp, .layoutSubviews], completion: {(_) in
            self.fillCellData()
        })
    }
    
    @objc fileprivate func tapForInfoAboutEducation() {
        educationInfo?.side = .name
        UIView.transition(from: self.trainerInfoContainerView, to: self.educationInfoContainerView, duration: 0.5, options: [.transitionCurlDown, .layoutSubviews], completion: {(_) in
            self.fillCellData()
        })
    }
    
    override func prepareForReuse() {
        educationInfo?.side = .name
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
