//
//  ChatLogController.swift
//  ankportal
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class ChatLogController: UICollectionViewController {

   var currentUser: [String:String]? = UserDefaults.standard.object(forKey: "CurrentUser") as? [String:String]
//    var currentUser: [String:String]? = nil
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Текст сообщения..."
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отпр", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    lazy var inputContainerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    lazy var separatorInputView: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor.white
        
        setupInputComponents()
        
        if (self.currentUser == nil) {
            getNewUser()
        } else {
            signInFireBase()
        }
        
    }
    
    func setupInputComponents() {
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        view.addSubview(inputContainerView)
        inputContainerView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor).isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputContainerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: safeLayoutGuide.rightAnchor, constant: -8).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        inputContainerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: safeLayoutGuide.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8).isActive = true
        
        inputContainerView.addSubview(separatorInputView)
        separatorInputView.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        separatorInputView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    }
    
    func getNewUser() {
        
        let getUserEmailAlert = UIAlertController(title: "Email", message: "Пожалуйста, представьтесь", preferredStyle: .alert)
        getUserEmailAlert.addTextField(configurationHandler: nil)
        getUserEmailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, getUserEmailAlert] (_) in
            let textField = getUserEmailAlert.textFields![0]
            if let text = textField.text {
                let user = ["userEmail": text, "userPass": text]
                self?.signUpFireBase(user: user)
            }
        }))
        
        getUserEmailAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(getUserEmailAlert, animated: true, completion: nil)
        }
    }
    
    func signUpFireBase(user: [String:String]) {
        Auth.auth().createUser(withEmail: user["userEmail"]!, password: user["userPass"]!) { (authResult, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.sendButton.isEnabled = true
            self.currentUser = user
            UserDefaults.standard.set(self.currentUser, forKey: "CurrentUser")
        }
    }
    
    func signInFireBase() {
        Auth.auth().signIn(withEmail: self.currentUser!["userEmail"]!, password: self.currentUser!["userPass"]!) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            
            if Auth.auth().currentUser != nil {
                self.sendButton.isEnabled = true
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.red
        // Configure the cell
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
}
