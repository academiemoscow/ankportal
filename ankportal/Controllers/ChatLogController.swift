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

    var messages: [Message] = [Message]()
    
    var currentUser: [String:String]? = UserDefaults.standard.object(forKey: "CurrentUser") as? [String:String]
//    var currentUser: [String:String]? = nil
//    var currentChatRoomId: String? = UserDefaults.standard.object(forKey: "CurrentChatRoomId") as? String
    var currentChatRoomId: String? = "-LWoUee8yUihyL0UnvWJ" //Временно, для тестов
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Текст сообщения..."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.delegate = self
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
    
    lazy var bottomInputsView: UIView = {
        let bv = UIView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.backgroundColor = UIColor.white
        return bv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.register(ChatLogChatBallonCellCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 58, right: 0)
        self.collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 15, left: 0, bottom: 50, right: 0)
        setupInputComponents()
        
        if (self.currentUser == nil) {
            getNewUser()
        } else {
            signInFireBase()
        }
        
        observeMessages()
        
    }
    
    func observeMessages() {
        if let roomId = self.currentChatRoomId {
            
            let ref = Database.database().reference().child("messages").child(roomId)
            print(ref)
            ref.observe(.childAdded) { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.setValuesForKeys(dict)
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
        }
    }
    
    func setupInputComponents() {
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        view.addSubview(bottomInputsView)
        bottomInputsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomInputsView.topAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -50).isActive = true
        bottomInputsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomInputsView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomInputsView.addSubview(inputContainerView)
        inputContainerView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor).isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: bottomInputsView.leftAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: bottomInputsView.widthAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputContainerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: safeLayoutGuide.rightAnchor, constant: -8).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        inputContainerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: safeLayoutGuide.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8).isActive = true
        
        inputContainerView.addSubview(separatorInputView)
        separatorInputView.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        separatorInputView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    }
    
    @objc func handleSend() {
        if let text = inputTextField.text {
            if text.count == 0 { return }
            if self.currentChatRoomId == nil {
                let ref = Database.database().reference().child("messages")
                self.currentChatRoomId = ref.childByAutoId().key
                UserDefaults.standard.set(self.currentChatRoomId, forKey: "CurrentChatRoomId")
            }
            let message = Message()
            message.chatRoomId = self.currentChatRoomId
            message.text = text
            message.saveFire { (error, ref) in
                if let error = error {
                    UIAlertController.displayError(withTitle: "Ошибка", withErrorText: error.localizedDescription, presentIn: self)
                    return
                }
                
                let msg = MessageToPush()
                msg.chatRoomId = message.chatRoomId
                msg.messageId = message.messageId
                msg.saveFire()
            }
            
            self.inputTextField.text = nil
        }
    }
    
    func getNewUser() {
        
        let getUserEmailAlert = UIAlertController(title: "Email", message: "Пожалуйста, представьтесь", preferredStyle: .alert)
        getUserEmailAlert.addTextField(configurationHandler: nil)
        getUserEmailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, getUserEmailAlert] (_) in
            let textField = getUserEmailAlert.textFields![0]
            if let text = textField.text {
                let dateReg = Date().timeIntervalSince1970
                let userEmail = "\(text + String(dateReg))@ankportal.ru"
                let user = ["userName": text, "userPass": userEmail, "userEmail": userEmail]
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
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            let ref =
                Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
            
            let userInfo = [
                "name"  : user["userName"]!,
                "email" : user["userEmail"]!,
                "type"  : "1"
                ]
            
            ref.updateChildValues(userInfo)
            
            self.sendButton.isEnabled = true
            self.currentUser = user
            UserDefaults.standard.set(self.currentUser, forKey: "CurrentUser")
        }
    }
    
    func signInFireBase() {
        Auth.auth().signIn(withEmail: self.currentUser!["userEmail"]!, password: self.currentUser!["userPass"]!) { (authResult, error) in
            if let error = error {
                if (error._code == 17011) { //There is not user record with this identifier, than create new
                    self.signUpFireBase(user: self.currentUser!)
                }
                UIAlertController.displayError(withTitle: "Ошибка", withErrorText: error.localizedDescription, presentIn: self)
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
        return self.messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatLogChatBallonCellCollectionViewCell
        // Configure the cell
        let size = estimateFrame(forText: messages[indexPath.row].text!)
        let width = size.width + 20
        cell.viewWidthAnchor.constant = width
        
        if (messages[indexPath.row].fromId != Auth.auth().currentUser?.uid) {
            cell.toLeftSide()
        } else {
            cell.toRightSide()
        }
        
        if let timestamp = self.messages[indexPath.row].timestamp {
            cell.timestamp = Double(exactly: timestamp)
        }
        cell.textLabel.text = self.messages[indexPath.row].text
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
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
    
    func estimateFrame(forText text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = estimateFrame(forText: messages[indexPath.row].text!)
        let height = size.height + 50
        return CGSize(width: self.view.frame.width, height: height)
    }
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.handleSend()
        return true
    }
}
