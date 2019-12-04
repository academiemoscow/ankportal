//
//  ducationInfoTableViewCell.swift
//  ankportal
//
//  Created by Олег on 04/12/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class EducationInfoTableViewCell: PlaceholderTableViewCell {
    private var educationModel: EducationPreview?
    
    override var backgroundColorForView: UIColor {
        get {
            return UIColor.white
        }
    }
    
    var educationId: String?
    var educationName: String?
    var educationCity: String?
    var educationDate: String?
    var doctorName: String?
    var doctorPhoto: UIImage?
    var doctorRegaly: String?
    var educationInfo: EducationInfoCell?
    
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
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.footnote)?.withSize(17)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.footnote)?.withSize(17)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let educationInfoTextLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)?.withSize(17)
        textView.textAlignment = NSTextAlignment.left
        textView.backgroundColor = UIColor.white
        textView.text = ""
        textView.isUserInteractionEnabled = true
//        textView.numberOfLines = 4
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.textAlignment = .natural
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let photoImageView: ImageLoader = {
        let photo = ImageLoader()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.layer.cornerRadius = 20
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.image = UIImage.init(named: "doctor")
        return photo
    }()
    
    let educationDoctorNameLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.callout)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.isEditable = false
        label.isSelectable = false
        label.isScrollEnabled = false
//        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationDoctorRegalyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.footnote)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 8
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var showTrainerInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 10
        button.setTitle("О тренере", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapForInfoAboutTrainer), for: .touchUpInside)
        
        return button
    }()
    
    lazy var registrationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 10
        button.setTitle("Записаться", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)?.withSize(19)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    lazy var showEducationInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 10
        button.setTitle("О семинаре", for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapForInfoAboutEducation), for: .touchUpInside)
        
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
    
    override func getContainterView() -> ShadowView {
        let view = ShadowView()
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = backgroundColorForView
        view.layer.borderWidth = 1
        view.shadowView.layer.cornerRadius = 10
        view.layer.borderColor = UIColor(r: 220, g: 220, b: 220).cgColor
        return view
    }
    
    func fillCellData() {
        self.photoImageView.image = UIImage.init(named: "doctor")
        self.educationDoctorNameLabel.text = "врач не назначен"
        self.educationDoctorRegalyLabel.text = ""
        
        self.educationId = educationInfo?.educationInfoFromJSON.id
        educationDateLabel.text = (educationInfo?.educationInfoFromJSON.date)!
        educationCityLabel.text = educationInfo?.educationInfoFromJSON.town
        educationInfoTextLabel.text = educationInfo?.educationInfoFromJSON.name
        if (educationInfo?.educationInfoFromJSON.doctorInfo!.count)! > 0 {
            if educationInfo?.educationInfoFromJSON.doctorInfo?[0].id != nil {
            educationDoctorNameLabel.text =  (educationInfo?.educationInfoFromJSON.doctorInfo?[0].doctorLastName)! + " " + (educationInfo?.educationInfoFromJSON.doctorInfo![0].doctorName)!
            educationDoctorRegalyLabel.text = educationInfo?.educationInfoFromJSON.doctorInfo?[0].workProfile?.htmlToString
            }
        }
        if (educationInfo?.educationInfoFromJSON.doctorInfo!.count)! > 0 {
                   let photoURL = URL(string: (educationInfo?.educationInfoFromJSON.doctorInfo![0].photoURL)!)
                   photoImageView.loadImageWithUrl(photoURL!)
               }
        setConstraints()
    }
    
    func setConstraints() {
        
        
        addSubview(educationInfoTextLabel)
        educationInfoTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: contentInsetLeftAndRight*3.6).isActive = true
        educationInfoTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: contentInsetLeftAndRight*3.4).isActive = true
        educationInfoTextLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        educationInfoTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentInsetLeftAndRight*3.6).isActive = true
        
        addSubview(registrationButton)
        registrationButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentInsetLeftAndRight*3.6).isActive = true
        registrationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsetLeftAndRight*3.4).isActive = true
        registrationButton.widthAnchor.constraint(equalToConstant: 141).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(photoImageView)
        photoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: contentInsetLeftAndRight*3.6).isActive = true
        photoImageView.topAnchor.constraint(equalTo: educationInfoTextLabel.bottomAnchor, constant: contentInsetLeftAndRight).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: registrationButton.leftAnchor, constant: -contentInsetLeftAndRight).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor).isActive = true
        
        addSubview(educationDoctorNameLabel)
        educationDoctorNameLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: contentInsetLeftAndRight-5).isActive = true
        educationDoctorNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentInsetLeftAndRight*3.6).isActive = true
        educationDoctorNameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor).isActive = true
        educationDoctorNameLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        addSubview(educationDoctorRegalyLabel)
        educationDoctorRegalyLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationDoctorRegalyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentInsetLeftAndRight*3.6).isActive = true
        educationDoctorRegalyLabel.topAnchor.constraint(equalTo: educationDoctorNameLabel.bottomAnchor,constant: contentInsetLeftAndRight).isActive = true
        educationDoctorRegalyLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor).isActive = true

        
        addSubview(educationDateLabel)
        educationDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: contentInsetLeftAndRight*3.6).isActive = true
        educationDateLabel.bottomAnchor.constraint(equalTo: registrationButton.bottomAnchor).isActive = true
        educationDateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        educationDateLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        addSubview(educationCityLabel)
        educationCityLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: contentInsetLeftAndRight*3.6).isActive = true
        educationCityLabel.topAnchor.constraint(equalTo: registrationButton.topAnchor).isActive = true
        educationCityLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        educationCityLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
    //        containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.backgroundColor = UIColor.white
        }
        
        override func prepareForReuse() {
            self.educationDoctorNameLabel.text = "врач не назначен"
            self.educationDoctorRegalyLabel.text = ""
            self.photoImageView.image = UIImage.init(named: "doctor")
        }
        
        func configure(forModel model: EducationPreview) {
            fillCellData()
            educationModel = model
            setupVisibillity()
        }
        
        private func setupVisibillity() {
            setupVisibillityBottomHStack()
            layoutIfNeeded()
        }
        
        private func setupVisibillityBottomHStack() {
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            fatalError("init(coder:) has not been implemented")
        }
    
    
}
