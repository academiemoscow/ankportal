//
//  EducationRegistrationViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 13/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class EducationRegistrationViewController: UIViewController, UIViewControllerTransitioningDelegate, UITextViewDelegate {
    
    var educationId: String?
    var educationName: String?
    var educationCity: String?
    var educationDate: String?
    var doctorName: String?
    var doctorPhoto: UIImage?
    var doctorRegaly: String?
    
    var educationNameLabel: UILabel = {
        var educationNameLabel = UILabel()
        educationNameLabel.font = UIFont.defaultFont(ofSize: 14)
        educationNameLabel.numberOfLines = 5
        educationNameLabel.backgroundColor = UIColor.ankPurple
        educationNameLabel.textAlignment = NSTextAlignment.left
        educationNameLabel.sizeToFit()
//        educationNameLabel.layer.cornerRadius = 37
        educationNameLabel.layer.masksToBounds = true
        educationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationNameLabel
    }()
    
    var educationDateTextLabel: UILabel = {
        var educationDateTextLabel = UILabel()
        educationDateTextLabel.font = UIFont.defaultFont(ofSize: 18)
        educationDateTextLabel.numberOfLines = 1
        educationDateTextLabel.backgroundColor = UIColor.ankPurple
        educationDateTextLabel.textAlignment = NSTextAlignment.center
        educationDateTextLabel.textColor = UIColor.black
        educationDateTextLabel.sizeToFit()
        educationDateTextLabel.layer.masksToBounds = true
        educationDateTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationDateTextLabel
    }()
    
    var educationNameTextLabel: UILabel = {
        var educationNameTextLabel = UILabel()
        educationNameTextLabel.font = UIFont.defaultFont(ofSize: 14)
        educationNameTextLabel.numberOfLines = 5
        educationNameTextLabel.backgroundColor = UIColor.ankPurple
        educationNameTextLabel.textAlignment = NSTextAlignment.center
        educationNameTextLabel.textColor = UIColor.black
        educationNameTextLabel.sizeToFit()
        educationNameTextLabel.layer.masksToBounds = true
        educationNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationNameTextLabel
    }()
    
    let userDataContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.backgroundColor
        return view
    }()
    
    var surnameLabelView: UILabel = {
        var surnameLabelView = UILabel()
        surnameLabelView.translatesAutoresizingMaskIntoConstraints = false
        surnameLabelView.font = UIFont.defaultFont(ofSize: 16)
        surnameLabelView.textColor = UIColor.black
        surnameLabelView.textAlignment = NSTextAlignment.left
        surnameLabelView.text = "Фамилия"
        surnameLabelView.layer.masksToBounds = true
        return surnameLabelView
    }()
    
    let surnameEditTextView: UITextView = {
        let surnameEditTextView = UITextView()
        surnameEditTextView.font = UIFont.defaultFont(ofSize: 16)
        surnameEditTextView.layer.borderColor = UIColor.black.cgColor
        surnameEditTextView.layer.borderWidth = 1
        surnameEditTextView.isEditable = true
        surnameEditTextView.textContainer.maximumNumberOfLines = 1
        surnameEditTextView.translatesAutoresizingMaskIntoConstraints = false
        return surnameEditTextView
    }()
    
    var nameLabelView: UILabel = {
        var surnameLabelView = UILabel()
        surnameLabelView.translatesAutoresizingMaskIntoConstraints = false
        surnameLabelView.font = UIFont.defaultFont(ofSize: 16)
        surnameLabelView.textColor = UIColor.black
        surnameLabelView.textAlignment = NSTextAlignment.left
        surnameLabelView.text = "Имя"
        surnameLabelView.layer.masksToBounds = true
        return surnameLabelView
    }()
    
    let nameEditTextView: UITextView = {
        let nameEditTextView = UITextView()
        nameEditTextView.font = UIFont.defaultFont(ofSize: 16)
        nameEditTextView.layer.borderColor = UIColor.black.cgColor
        nameEditTextView.layer.borderWidth = 1
        nameEditTextView.isEditable = true
        nameEditTextView.resignFirstResponder()
        nameEditTextView.textContainer.maximumNumberOfLines = 1
        nameEditTextView.translatesAutoresizingMaskIntoConstraints = false
        return nameEditTextView
    }()
    
    var lastnameLabelView: UILabel = {
        var surnameLabelView = UILabel()
        surnameLabelView.translatesAutoresizingMaskIntoConstraints = false
        surnameLabelView.font = UIFont.defaultFont(ofSize: 16)
        surnameLabelView.textColor = UIColor.black
        surnameLabelView.textAlignment = NSTextAlignment.left
        surnameLabelView.text = "Отчество"
        surnameLabelView.layer.masksToBounds = true
        return surnameLabelView
    }()
    
    let lastnameEditTextView: UITextView = {
        let lastnameEditTextView = UITextView()
        lastnameEditTextView.font = UIFont.defaultFont(ofSize: 16)
        lastnameEditTextView.layer.borderColor = UIColor.black.cgColor
        lastnameEditTextView.layer.borderWidth = 1
        lastnameEditTextView.isEditable = true
        lastnameEditTextView.translatesAutoresizingMaskIntoConstraints = false
        lastnameEditTextView.textContainer.maximumNumberOfLines = 1
        return lastnameEditTextView
    }()
    
    var phoneLabelView: UILabel = {
        var surnameLabelView = UILabel()
        surnameLabelView.translatesAutoresizingMaskIntoConstraints = false
        surnameLabelView.font = UIFont.defaultFont(ofSize: 16)
        surnameLabelView.textColor = UIColor.black
        surnameLabelView.textAlignment = NSTextAlignment.left
        surnameLabelView.text = "Телефон"
        surnameLabelView.layer.masksToBounds = true
        return surnameLabelView
    }()
    
    let phoneEditTextView: UITextView = {
        let phoneEditTextView = UITextView()
        phoneEditTextView.font = UIFont.defaultFont(ofSize: 16)
        phoneEditTextView.layer.borderColor = UIColor.black.cgColor
        phoneEditTextView.layer.borderWidth = 1
        phoneEditTextView.isEditable = true
        phoneEditTextView.keyboardType = UIKeyboardType.decimalPad
        phoneEditTextView.translatesAutoresizingMaskIntoConstraints = false
        phoneEditTextView.textContainer.maximumNumberOfLines = 1
        phoneEditTextView.tag = 4
        return phoneEditTextView
    }()
    
    var emailLabelView: UILabel = {
        var emailLabelView = UILabel()
        emailLabelView.translatesAutoresizingMaskIntoConstraints = false
        emailLabelView.font = UIFont.defaultFont(ofSize: 16)
        emailLabelView.textColor = UIColor.black
        emailLabelView.textAlignment = NSTextAlignment.left
        emailLabelView.text = "E-mail"
        emailLabelView.layer.masksToBounds = true
        return emailLabelView
    }()
    
    let emailEditTextView: UITextView = {
        let emailEditTextView = UITextView()
        emailEditTextView.font = UIFont.defaultFont(ofSize: 16)
        emailEditTextView.layer.borderColor = UIColor.black.cgColor
        emailEditTextView.layer.borderWidth = 1
        emailEditTextView.isEditable = true
        emailEditTextView.adjustsFontForContentSizeCategory = true
        emailEditTextView.textContainer.maximumNumberOfLines = 1
        emailEditTextView.keyboardType = UIKeyboardType.emailAddress
        emailEditTextView.translatesAutoresizingMaskIntoConstraints = false
        return emailEditTextView
    }()
    
    var cityLabelView: UILabel = {
        var cityLabelView = UILabel()
        cityLabelView.translatesAutoresizingMaskIntoConstraints = false
        cityLabelView.font = UIFont.defaultFont(ofSize: 16)
        cityLabelView.textColor = UIColor.black
        cityLabelView.textAlignment = NSTextAlignment.left
        cityLabelView.text = "Город"
        cityLabelView.layer.masksToBounds = true
        return cityLabelView
    }()
    
    let cityEditTextView: UITextView = {
        let cityEditTextView = UITextView()
        cityEditTextView.font = UIFont.defaultFont(ofSize: 16)
        cityEditTextView.layer.borderColor = UIColor.black.cgColor
        cityEditTextView.layer.borderWidth = 1
        cityEditTextView.isEditable = true
        cityEditTextView.textContainer.maximumNumberOfLines = 1
        cityEditTextView.translatesAutoresizingMaskIntoConstraints = false
        cityEditTextView.tag = 6
        return cityEditTextView
    }()
    
    lazy var commitRegistrationButton: UIButton = {
        var commitRegistrationButton = UIButton()
        commitRegistrationButton.setImage(UIImage(named: "apply_icon"), for: .normal)
        commitRegistrationButton.backgroundColor = UIColor.ballonGrey
        commitRegistrationButton.layer.cornerRadius = 22
        commitRegistrationButton.translatesAutoresizingMaskIntoConstraints = false
        commitRegistrationButton.addTarget(self, action: #selector(hideAndCommitRegistration), for: .touchUpInside)
        return commitRegistrationButton
    }()
    
    @objc func hideAndCommitRegistration() {
        var correctInfoKey = true
        if surnameEditTextView.text == "" {
            surnameEditTextView.layer.borderColor = UIColor.red.cgColor
            correctInfoKey = false
        }
        if nameEditTextView.text == "" {
            nameEditTextView.layer.borderColor = UIColor.red.cgColor
            correctInfoKey = false
        }
        if phoneEditTextView.text.count < 5 {
            phoneEditTextView.layer.borderColor = UIColor.red.cgColor
            correctInfoKey = false
        }
        if emailEditTextView.text.count < 5 {
            emailEditTextView.layer.borderColor = UIColor.red.cgColor
            correctInfoKey = false
        }
        if cityEditTextView.text.count < 3 {
            cityEditTextView.layer.borderColor = UIColor.red.cgColor
            correctInfoKey = false
        }
        if !agreeSwitch.isOn {
            agreementLabelView.textColor = UIColor.red
            correctInfoKey = false
        }
        if correctInfoKey {
            setNewRegistration()
        } else {
            let vibrationGenerator = UINotificationFeedbackGenerator()
            vibrationGenerator.notificationOccurred(.error)
        }
    }
    
    func setNewRegistration() {
        let vibrationGenerator = UIImpactFeedbackGenerator()
        vibrationGenerator.impactOccurred()
        
        let firstName = nameEditTextView.text
        let secondName = surnameEditTextView.text
        //  let lastName = lastnameEditTextView.text
        let phone = phoneEditTextView.text
        let email = emailEditTextView.text
        let smName = educationNameTextLabel.text
        let smTown = educationCity
        let smTime = educationDate
        
        let urlString = "https://ankportal.ru/bitrix/components/pitcom/zapis/" + "ajax.php?type=zapis&name=" + firstName! + "&firstname=" + firstName! + "&secondname=" + secondName! + "&phone=" + phone! + "&email=" + email! + "&smName=" + smName! + "&smId=" + educationId! + "&smTown=" + smTown! + "&smTime=" + smTime!
        
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let myURL = URL(string: encodedUrlString!)
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.commitRegistrationButton.imageView?.image = nil
            self.activityIndicator.startAnimating()
        }
        URLSession.shared.dataTask(with: myURL!)      { (data, response, err) in
            // guard let data = data else { return }
            do {
                let alert = UIAlertController(title: "Регистрация", message: "Благодарим за регистрацию! В ближайшее время с Вами свяжется наш менеджер :)", preferredStyle: UIAlertController.Style.alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(alertAction)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
                self.present(alert, animated: true, completion: nil)
            }
            }.resume()
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.tintColor = UIColor.black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var declineRegistrationButton: UIButton = {
        var declineRegistrationButton = UIButton()
        declineRegistrationButton.setImage(UIImage(named: "decline_icon"), for: .normal)
        declineRegistrationButton.backgroundColor = UIColor.ballonGrey
        declineRegistrationButton.layer.cornerRadius = 22
        declineRegistrationButton.translatesAutoresizingMaskIntoConstraints = false
        declineRegistrationButton.addTarget(self, action: #selector(hideAndDeclineRegistration), for: .touchUpInside)
        return declineRegistrationButton
    }()
    @objc func hideAndDeclineRegistration()  {
        let vibrationGenerator = UIImpactFeedbackGenerator()
        vibrationGenerator.impactOccurred()
        dismiss(animated: true, completion: nil)
    }
    
    var agreeSwitch: UISwitch = {
        var agreeSwitch = UISwitch()
        agreeSwitch.isOn = false
        agreeSwitch.isEnabled = true
        agreeSwitch.translatesAutoresizingMaskIntoConstraints = false
        agreeSwitch.backgroundColor = UIColor.sectionUnderlineColor
        agreeSwitch.layer.cornerRadius = 18
        agreeSwitch.addTarget(self, action: #selector(agreeSwitchTap), for: UIControl.Event.touchUpInside)
        return agreeSwitch
    }()
    @objc func agreeSwitchTap() {
        tapAway()
        if agreeSwitch.isOn {
            agreementLabelView.textColor = UIColor.black
        } else {
            agreementLabelView.textColor = UIColor.red
        }
    }
    
    var agreementLabelView: UILabel = {
        var agreementLabelView = UILabel()
        agreementLabelView.translatesAutoresizingMaskIntoConstraints = false
        agreementLabelView.font = UIFont.defaultFont(ofSize: 12)
        agreementLabelView.textColor = UIColor.black
        agreementLabelView.numberOfLines = 2
        agreementLabelView.textAlignment = NSTextAlignment.left
        agreementLabelView.text = "Я согласен на хранение и обработку моих персональных данных"
        agreementLabelView.layer.masksToBounds = true
        return agreementLabelView
    }()
    
    let educationZPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(ofSize: 18)
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
        label.font = UIFont.defaultFont(ofSize: 18)
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
    
    var lastEditedText: String = ""
    
    func textViewDidChange(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.black.cgColor
        if textView.text.last == "\n" {
            let editedString = textView.text.dropLast(1)
            textView.text = String(editedString)
            tapAway()
        }
        if textView.tag == 4 {
            var editedString = textView.text
            if editedString?.count == 1 {
                if lastEditedText.firstIndex(of: "(") == nil{
                    editedString = editedString! + "("}
                else {editedString = ""}
            }
            if editedString?.count == 5 {
                if lastEditedText.firstIndex(of: ")") == nil{
                    editedString = editedString! + ")"}
                else {editedString = String(textView.text.dropLast(1))}
            }
            if editedString?.count == 9 {
                if lastEditedText.firstIndex(of: "-") == nil{
                    editedString = editedString! + "-"}
                else {editedString = String(textView.text.dropLast(1))}
            }
            textView.text = editedString
        }
        lastEditedText = textView.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = UIColor.backgroundColor
        
        view.addSubview(educationNameLabel)
        educationNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        educationNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        educationNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        educationNameLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        view.addSubview(userDataContainerView)
        userDataContainerView.topAnchor.constraint(equalTo: educationNameLabel.bottomAnchor, constant: 10).isActive = true
        userDataContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userDataContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        userDataContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        educationNameLabel.addSubview(educationNameTextLabel)
        educationNameTextLabel.bottomAnchor.constraint(equalTo: educationNameLabel.bottomAnchor).isActive = true
        educationNameTextLabel.widthAnchor.constraint(equalTo: educationNameLabel.widthAnchor, constant: -10).isActive = true
        educationNameTextLabel.heightAnchor.constraint(equalTo: educationNameLabel.heightAnchor, multiplier: 0.55).isActive = true
        educationNameTextLabel.centerXAnchor.constraint(equalTo: educationNameLabel.centerXAnchor).isActive = true
        educationNameTextLabel.text = educationName
        
        educationNameLabel.addSubview(educationDateTextLabel)
        educationDateTextLabel.topAnchor.constraint(equalTo: educationNameLabel.topAnchor, constant: 30).isActive = true
        educationDateTextLabel.widthAnchor.constraint(equalTo: educationNameLabel.widthAnchor).isActive = true
        educationDateTextLabel.bottomAnchor.constraint(equalTo: educationNameTextLabel.topAnchor).isActive = true
        educationDateTextLabel.centerXAnchor.constraint(equalTo: educationNameLabel.centerXAnchor).isActive = true
        educationDateTextLabel.text = educationDate
//        educationDateTextLabel.backgroundColor = UIColor.red
        
        userDataContainerView.addSubview(surnameLabelView)
        surnameLabelView.topAnchor.constraint(equalTo: userDataContainerView.topAnchor,constant: contentInsetLeftAndRight*2).isActive = true
        surnameLabelView.leftAnchor.constraint(equalTo: userDataContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        surnameLabelView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        surnameLabelView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        let textEditHeight: CGFloat = 40
        let topDifBetweenViews: CGFloat = 46
        
        userDataContainerView.addSubview(surnameEditTextView)
        surnameEditTextView.heightAnchor.constraint(equalToConstant: textEditHeight).isActive = true
        surnameEditTextView.centerYAnchor.constraint(equalTo: surnameLabelView.centerYAnchor).isActive = true
        surnameEditTextView.leftAnchor.constraint(equalTo: surnameLabelView.rightAnchor).isActive = true
        surnameEditTextView.rightAnchor.constraint(equalTo: userDataContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        surnameEditTextView.delegate = self
        
        userDataContainerView.addSubview(nameLabelView)
        nameLabelView.topAnchor.constraint(equalTo: surnameLabelView.topAnchor,constant: topDifBetweenViews).isActive = true
        nameLabelView.leftAnchor.constraint(equalTo: userDataContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        nameLabelView.widthAnchor.constraint(equalTo: surnameLabelView.widthAnchor).isActive = true
        nameLabelView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        userDataContainerView.addSubview(nameEditTextView)
        nameEditTextView.heightAnchor.constraint(equalToConstant: textEditHeight).isActive = true
        nameEditTextView.centerYAnchor.constraint(equalTo: nameLabelView.centerYAnchor).isActive = true
        nameEditTextView.leftAnchor.constraint(equalTo: nameLabelView.rightAnchor).isActive = true
        nameEditTextView.rightAnchor.constraint(equalTo: userDataContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        nameEditTextView.delegate = self
        
        userDataContainerView.addSubview(lastnameLabelView)
        lastnameLabelView.topAnchor.constraint(equalTo: nameLabelView.topAnchor,constant: topDifBetweenViews).isActive = true
        lastnameLabelView.leftAnchor.constraint(equalTo: userDataContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        lastnameLabelView.widthAnchor.constraint(equalTo: surnameLabelView.widthAnchor).isActive = true
        lastnameLabelView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        userDataContainerView.addSubview(lastnameEditTextView)
        lastnameEditTextView.heightAnchor.constraint(equalToConstant: textEditHeight).isActive = true
        lastnameEditTextView.centerYAnchor.constraint(equalTo: lastnameLabelView.centerYAnchor).isActive = true
        lastnameEditTextView.leftAnchor.constraint(equalTo: nameLabelView.rightAnchor).isActive = true
        lastnameEditTextView.rightAnchor.constraint(equalTo: userDataContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        lastnameEditTextView.delegate = self
        
        userDataContainerView.addSubview(phoneLabelView)
        phoneLabelView.topAnchor.constraint(equalTo: lastnameLabelView.topAnchor,constant: topDifBetweenViews).isActive = true
        phoneLabelView.leftAnchor.constraint(equalTo: userDataContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        phoneLabelView.widthAnchor.constraint(equalTo: surnameLabelView.widthAnchor).isActive = true
        phoneLabelView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        userDataContainerView.addSubview(phoneEditTextView)
        phoneEditTextView.heightAnchor.constraint(equalToConstant: textEditHeight).isActive = true
        phoneEditTextView.centerYAnchor.constraint(equalTo: phoneLabelView.centerYAnchor).isActive = true
        phoneEditTextView.leftAnchor.constraint(equalTo: nameLabelView.rightAnchor).isActive = true
        phoneEditTextView.rightAnchor.constraint(equalTo: userDataContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        phoneEditTextView.delegate = self
        
        userDataContainerView.addSubview(emailLabelView)
        emailLabelView.topAnchor.constraint(equalTo: phoneLabelView.topAnchor,constant: topDifBetweenViews).isActive = true
        emailLabelView.leftAnchor.constraint(equalTo: userDataContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        emailLabelView.widthAnchor.constraint(equalTo: surnameLabelView.widthAnchor).isActive = true
        emailLabelView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        userDataContainerView.addSubview(emailEditTextView)
        emailEditTextView.heightAnchor.constraint(equalToConstant: textEditHeight).isActive = true
        emailEditTextView.centerYAnchor.constraint(equalTo: emailLabelView.centerYAnchor).isActive = true
        emailEditTextView.leftAnchor.constraint(equalTo: nameLabelView.rightAnchor).isActive = true
        emailEditTextView.rightAnchor.constraint(equalTo: userDataContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        emailEditTextView.delegate = self
        
        userDataContainerView.addSubview(cityLabelView)
        cityLabelView.topAnchor.constraint(equalTo: emailLabelView.topAnchor,constant: topDifBetweenViews).isActive = true
        cityLabelView.leftAnchor.constraint(equalTo: userDataContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        cityLabelView.widthAnchor.constraint(equalTo: surnameLabelView.widthAnchor).isActive = true
        cityLabelView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        userDataContainerView.addSubview(cityEditTextView)
        cityEditTextView.heightAnchor.constraint(equalToConstant: textEditHeight).isActive = true
        cityEditTextView.centerYAnchor.constraint(equalTo: cityLabelView.centerYAnchor).isActive = true
        cityEditTextView.leftAnchor.constraint(equalTo: nameLabelView.rightAnchor).isActive = true
        cityEditTextView.rightAnchor.constraint(equalTo: userDataContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        cityEditTextView.delegate = self
        cityEditTextView.text = educationCity
        
        userDataContainerView.addSubview(agreeSwitch)
        agreeSwitch.topAnchor.constraint(equalTo: cityLabelView.topAnchor,constant: topDifBetweenViews).isActive = true
        agreeSwitch.leftAnchor.constraint(equalTo: userDataContainerView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        
        userDataContainerView.addSubview(agreementLabelView)
        agreementLabelView.heightAnchor.constraint(equalToConstant: textEditHeight).isActive = true
        agreementLabelView.centerYAnchor.constraint(equalTo: agreeSwitch.centerYAnchor).isActive = true
        agreementLabelView.leftAnchor.constraint(equalTo: cityLabelView.rightAnchor).isActive = true
        agreementLabelView.rightAnchor.constraint(equalTo: userDataContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        
        userDataContainerView.addSubview(educationZPLabel)
        educationZPLabel.leftAnchor.constraint(equalTo: agreeSwitch.leftAnchor).isActive = true
        educationZPLabel.topAnchor.constraint(equalTo: agreeSwitch.bottomAnchor, constant: topDifBetweenViews/2).isActive = true
        educationZPLabel.widthAnchor.constraint(equalTo: userDataContainerView.widthAnchor).isActive = true
        educationZPLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        userDataContainerView.addSubview(photoImageView)
        let widthAndHeightPhoto = view.frame.size.width * 0.25
        photoImageView.image = doctorPhoto
        photoImageView.leftAnchor.constraint(equalTo: educationZPLabel.leftAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: educationZPLabel.bottomAnchor, constant: 5).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: widthAndHeightPhoto).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: widthAndHeightPhoto).isActive = true
        
        userDataContainerView.addSubview(educationDoctorNameLabel)
        educationDoctorNameLabel.text = doctorName
        educationDoctorNameLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 5).isActive = true
        educationDoctorNameLabel.topAnchor.constraint(equalTo: educationZPLabel.bottomAnchor, constant: 5).isActive = true
        educationDoctorNameLabel.rightAnchor.constraint(equalTo: userDataContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        educationDoctorNameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        userDataContainerView.addSubview(educationDoctorRegalyLabel)
        educationDoctorRegalyLabel.text = doctorRegaly
        educationDoctorRegalyLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 5).isActive = true
        educationDoctorRegalyLabel.topAnchor.constraint(equalTo: educationDoctorNameLabel.bottomAnchor).isActive = true
        educationDoctorRegalyLabel.rightAnchor.constraint(equalTo: userDataContainerView.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        educationDoctorRegalyLabel.heightAnchor.constraint(equalToConstant: widthAndHeightPhoto - 25).isActive = true
        
        view.addSubview(commitRegistrationButton)
        let buttonSize: CGFloat = 45
        let curViewHeight: CGFloat = 667
        let phoneViewHeight: CGFloat = view.layer.frame.size.height
        var koef: CGFloat = 2
        if phoneViewHeight < curViewHeight {
            educationZPLabel.isHidden = true
            educationDoctorNameLabel.isHidden = true
            educationDoctorRegalyLabel.isHidden = true
            photoImageView.isHidden = true
            koef = 1
        }
        let buttonY = curViewHeight + (phoneViewHeight - curViewHeight) / koef - buttonSize
        commitRegistrationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonY - 10).isActive = true
        commitRegistrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.layer.frame.size.width / 4).isActive = true
        commitRegistrationButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        commitRegistrationButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        commitRegistrationButton.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: commitRegistrationButton.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: commitRegistrationButton.centerXAnchor).isActive = true
        activityIndicator.isHidden = true
        
        view.addSubview(declineRegistrationButton)
        declineRegistrationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonY - 10).isActive = true
        declineRegistrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.layer.frame.size.width / 4).isActive = true
        declineRegistrationButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        declineRegistrationButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(tapAway))
        userDataContainerView.addGestureRecognizer(gestureRecogniser)
        
        view.addSubview(commitRegistrationButton)
    }
    
    
    @objc func tapAway(){
        surnameEditTextView.resignFirstResponder()
        nameEditTextView.resignFirstResponder()
        lastnameEditTextView.resignFirstResponder()
        phoneEditTextView.resignFirstResponder()
        emailEditTextView.resignFirstResponder()
        cityEditTextView.resignFirstResponder()
    }
    
}
