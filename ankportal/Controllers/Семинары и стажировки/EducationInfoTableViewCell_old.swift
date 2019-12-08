//
//  EducationTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 10/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

//
//  ProductTableViewCell.swift
//  ankportal
//
//  Created by Admin on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class EducationInfoTableViewCell_old: PlaceholderTableViewCell {
    
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
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.footnote)?.withSize(16)
        label.textAlignment = NSTextAlignment.left
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.footnote)?.withSize(16)
        label.textAlignment = NSTextAlignment.right
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let educationInfoTextLabel: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.subheadline)?.withSize(14)
        textView.textAlignment = NSTextAlignment.left
        textView.backgroundColor = UIColor.white
        textView.text = ""
        textView.isUserInteractionEnabled = true
        textView.numberOfLines = 4
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
        button.titleLabel?.font = UIFont.defaultFont(forTextStyle: UIFont.TextStyle.headline)
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
        self.educationId = educationInfo?.educationInfoFromJSON.id
        educationDateLabel.text = educationInfo?.educationInfoFromJSON.date
        educationCityLabel.text = educationInfo?.educationInfoFromJSON.town
        educationInfoTextLabel.text = educationInfo?.educationInfoFromJSON.name
        if (educationInfo?.educationInfoFromJSON.doctorInfo!.count)! > 0 {
            if educationInfo?.educationInfoFromJSON.doctorInfo?[0].id != nil {
            educationDoctorNameLabel.text =  (educationInfo?.educationInfoFromJSON.doctorInfo?[0].doctorLastName)! + " " + (educationInfo?.educationInfoFromJSON.doctorInfo![0].doctorName)!
            educationDoctorRegalyLabel.text = educationInfo?.educationInfoFromJSON.doctorInfo?[0].workProfile?.htmlToString
            }
        }
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
        
        contentView.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding/2).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding/2).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor, constant: -padding).isActive = true
        
        containerView.addSubview(educationInfoContainerView)
        educationInfoContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        educationInfoContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        educationInfoContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        educationInfoContainerView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        educationInfoContainerView.addSubview(educationDateLabel)
        educationDateLabel.leftAnchor.constraint(equalTo: educationInfoContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationDateLabel.topAnchor.constraint(equalTo: educationInfoContainerView.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationDateLabel.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, multiplier: 0.6).isActive = true
        educationDateLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        educationInfoContainerView.addSubview(educationCityLabel)
        educationCityLabel.rightAnchor.constraint(equalTo: educationInfoContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        educationCityLabel.topAnchor.constraint(equalTo: educationInfoContainerView.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationCityLabel.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, multiplier: 0.4).isActive = true
        educationCityLabel.heightAnchor.constraint(equalTo: educationDateLabel.heightAnchor).isActive = true
        
        educationInfoContainerView.addSubview(educationInfoTextLabel)
        educationInfoTextLabel.leftAnchor.constraint(equalTo: educationInfoContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationInfoTextLabel.topAnchor.constraint(equalTo: educationDateLabel.bottomAnchor).isActive = true
        educationInfoTextLabel.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, constant: -contentInsetLeftAndRight).isActive = true
        educationInfoTextLabel.bottomAnchor.constraint(equalTo: educationInfoContainerView.bottomAnchor, constant: -(60 - contentInsetLeftAndRight*2)).isActive = true
        
        educationInfoContainerView.addSubview(registrationButton)
        registrationButton.rightAnchor.constraint(equalTo: educationInfoContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        registrationButton.bottomAnchor.constraint(equalTo: educationInfoContainerView.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        registrationButton.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, multiplier: 0.35).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 60 - contentInsetLeftAndRight*2).isActive = true
        
        educationInfoContainerView.addSubview(showTrainerInfoButton)
        showTrainerInfoButton.leftAnchor.constraint(equalTo: educationInfoContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        showTrainerInfoButton.bottomAnchor.constraint(equalTo: educationInfoContainerView.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        showTrainerInfoButton.widthAnchor.constraint(equalTo: educationInfoContainerView.widthAnchor, multiplier: 0.35).isActive = true
        showTrainerInfoButton.heightAnchor.constraint(equalToConstant: 60 - contentInsetLeftAndRight*2).isActive = true
        
    }
    
    func setConstraintsForTrainerSide() {
        
        contentView.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding/2).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding/2).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor, constant: -padding).isActive = true
        
        containerView.addSubview(trainerInfoContainerView)
        trainerInfoContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        trainerInfoContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        trainerInfoContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        trainerInfoContainerView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        trainerInfoContainerView.addSubview(showEducationInfoButton)
        showEducationInfoButton.leftAnchor.constraint(equalTo: trainerInfoContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        showEducationInfoButton.bottomAnchor.constraint(equalTo: trainerInfoContainerView.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        showEducationInfoButton.widthAnchor.constraint(equalTo: trainerInfoContainerView.widthAnchor, multiplier: 0.35).isActive = true
        showEducationInfoButton.heightAnchor.constraint(equalToConstant: 60 - contentInsetLeftAndRight*2).isActive = true
        
        trainerInfoContainerView.addSubview(photoImageView)
        photoImageView.leftAnchor.constraint(equalTo: trainerInfoContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: showEducationInfoButton.topAnchor, constant: -contentInsetLeftAndRight).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: showEducationInfoButton.widthAnchor) .isActive = true
        photoImageView.topAnchor.constraint(equalTo: trainerInfoContainerView.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        
        trainerInfoContainerView.addSubview(educationDoctorNameLabel)
        educationDoctorNameLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationDoctorNameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor).isActive = true
        educationDoctorNameLabel.rightAnchor.constraint(equalTo: rightAnchor,  constant: -contentInsetLeftAndRight).isActive = true
        educationDoctorNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        trainerInfoContainerView.addSubview(educationDoctorRegalyLabel)
        educationDoctorRegalyLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: contentInsetLeftAndRight).isActive = true
        educationDoctorRegalyLabel.topAnchor.constraint(equalTo: educationDoctorNameLabel.bottomAnchor).isActive = true
        educationDoctorRegalyLabel.rightAnchor.constraint(equalTo: trainerInfoContainerView.rightAnchor).isActive = true
        educationDoctorRegalyLabel.bottomAnchor.constraint(equalTo: showEducationInfoButton.topAnchor, constant: -contentInsetLeftAndRight).isActive = true
        
        trainerInfoContainerView.addSubview(registrationButton)
        registrationButton.rightAnchor.constraint(equalTo: trainerInfoContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        registrationButton.bottomAnchor.constraint(equalTo: trainerInfoContainerView.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        registrationButton.widthAnchor.constraint(equalTo: trainerInfoContainerView.widthAnchor, multiplier: 0.35).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 60 - contentInsetLeftAndRight*2).isActive = true
        
        if (educationInfo?.educationInfoFromJSON.doctorInfo!.count)! > 0 {
            let photoURL = URL(string: (educationInfo?.educationInfoFromJSON.doctorInfo![0].photoURL)!)
            photoImageView.loadImageWithUrl(photoURL!)
        }
        
    }
    
    lazy var scalePropertyAnimation: UIViewPropertyAnimator = {
        
        let propertyAnimation = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
            self.containerView.transform = CGAffineTransform.identity
            //            self.containerView.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 1, 0, 0)
            self.containerView.layer.opacity = 1//0.3
        })
        propertyAnimation.pausesOnCompletion = true
        return propertyAnimation
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.backgroundColor = UIColor.white
    }
    
    override func prepareForReuse() {
        self.educationDoctorNameLabel.text = ""
        scalePropertyAnimation.fractionComplete = 1.0
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
