//
//  ChatLogController.swift
//  ankportal
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class ChatLogController: UICollectionViewController {

    
    private let cellOutgoing = "CellOutgoing"
    private let cellIncoming = "CellIncoming"
    
    private var refreshingFlag: Bool = false
    
    var firMessageObserver: FIRMessageObservable?
    
    var currentUser: [String:String]? = UserDefaults.standard.object(forKey: "CurrentUser") as? [String:String]
//    var currentUser: [String:String]? = nil
//    var currentChatRoomId: String? = UserDefaults.standard.object(forKey: "CurrentChatRoomId") as? String
    var currentChatRoomId: String? = "-LWoUee8yUihyL0UnvWJ" //Временно, для тестов
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.color = UIColor.black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        return indicator
    }()
    
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
        return button
    }()
    
    lazy var attachMedia: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var inputContainerViewBottomAnchor: NSLayoutConstraint = {
        let constraint = inputContainerView.bottomAnchor.constraint(equalTo: self.safeLayoutGuide.bottomAnchor)
        return constraint
    }()
    
    lazy var safeLayoutGuide: UILayoutGuide = {
        return view.safeAreaLayoutGuide
    }()
    
    lazy var collectionViewHeightAnchor: NSLayoutConstraint = {
        let constraint = self.collectionView!.heightAnchor.constraint(equalToConstant: 100)
        constraint.isActive = true
        return constraint
    }()
    
    private var messagesReference: DatabaseReference?
    private var firstLoadComplete: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        setupCollectionView()
        setupInputComponents()
    
        login()
        self.firMessageObserver = FIRMessageObservable(onChatRoomId: currentChatRoomId!)
        self.firMessageObserver?.addObserver(self)
    
        NetworkStatus.addObserver(self)
    }
    
    private func login() {
        if (self.currentUser == nil) {
            getNewUser()
        } else {
            signInFireBase()
        }
    }
    
    private func getNewUser() {
        
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
        
        self.present(getUserEmailAlert, animated: true, completion: nil)
    }
    
    private func signUpFireBase(user: [String:String]) {
        Auth.auth().createUser(withEmail: user["userEmail"]!, password: user["userPass"]!) {[weak self] (authResult, error) in
            if let error = error {
                print(error)
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
            
            self?.firMessageObserver?.start()
            self?.currentUser = user
            UserDefaults.standard.set(self?.currentUser, forKey: "CurrentUser")
            
            self?.updateChatRoomUsers()
            InstanceID.instanceID().instanceID(handler: { (result, error) in
                self?.updatefcmToken(token: result!.token)
            })
        }
    }
    
    private func updatefcmToken(token: String) {
        let ref =
            Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        let userInfo = [
            "fcmToken"  : token
        ]
        
        ref.updateChildValues(userInfo)
    }
    
    private func updateChatRoomUsers() {
        if let roomId = self.currentChatRoomId {
            let ref =
                Database.database().reference().child("room-user")
                    .child(roomId)
                    .child(Auth.auth().currentUser!.uid)
            
            let userInfo = [
                "userId"  : Auth.auth().currentUser!.uid
            ]
            
            ref.updateChildValues(userInfo)
        }
    }
    
    private func signInFireBase() {
        Auth.auth().signIn(withEmail: self.currentUser!["userEmail"]!, password: self.currentUser!["userPass"]!) { [weak self] (authResult, error) in
            if let error = error {
                if (error._code == 17011) { //There is not user record with this identifier, than create new
                    self?.signUpFireBase(user: self!.currentUser!)
                }
                print(error)
                return
            }
            
            if Auth.auth().currentUser != nil {
                self?.firMessageObserver?.start()
                self?.sendButton.isEnabled = true
                
                self?.updateChatRoomUsers()
                InstanceID.instanceID().instanceID(handler: { (result, error) in
                    self?.updatefcmToken(token: result!.token)
                })
                
            }
        }
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc private func handleRefreshControl(sender: UIRefreshControl) {
        self.firMessageObserver?.getPreviousMessages()
    }
    
    private func setupController() {
        self.navigationItem.title = "Чат"
    }
    
    private func setupCollectionView() {
        view.backgroundColor = UIColor.white
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionViewHeightAnchor.constant = 200
        
        self.collectionView?.register(OutgoingMessageCell.self, forCellWithReuseIdentifier: cellOutgoing)
        self.collectionView?.register(IncomingMessageCell.self, forCellWithReuseIdentifier: cellIncoming)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.alwaysBounceVertical = true
        
        self.collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 60, right: 0)
        self.collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 60, right: 0)
    
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.collectionView?.addGestureRecognizer(tapGesture)
    }
    
    private func setupInputComponents() {
        
        view.addSubview(inputContainerView)
        inputContainerViewBottomAnchor.isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [attachMedia, inputTextField, sendButton])
        stackView.isBaselineRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = UIColor.black
        
        inputContainerView.addSubview(stackView)
        attachMedia.widthAnchor.constraint(equalToConstant: 40).isActive = true
        attachMedia.addTarget(self, action: #selector(handleAttachMedia), for: .touchUpInside)
        
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        stackView.leftAnchor.constraint(equalTo: safeLayoutGuide.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: safeLayoutGuide.rightAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor).isActive = true
        
        inputContainerView.addSubview(separatorInputView)
        separatorInputView.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        separatorInputView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        adjustingHeight(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    private func adjustingHeight(_ show:Bool, notification:Notification) {
        var userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let k: CGFloat = show ? 1 : 0
        let changeInHeight = (keyboardFrame.height ) * k
        let safeAreaBottomInset = tabBarController?.tabBar.frame.height ?? UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        
        self.view.frame.origin.y = -changeInHeight + (safeAreaBottomInset) * k
        UIView.animate(withDuration: animationDurarion, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func scrollToLastItem() {
        if let itemCount = self.firMessageObserver?.messages.count, itemCount > 0 {
            let indexPath = IndexPath(row: itemCount - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc private func handleSend() {
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
            message.fromId = Auth.auth().currentUser?.uid
            
            self.firMessageObserver?.sendMessage(message: message, completionHandler: { (error, ref) in
                if let error = error {
                    UIAlertController.displayError(withTitle: "Ошибка", withErrorText: error.localizedDescription, presentIn: self)
                    return
                }
                let now = NSNumber.intervalSince1970()
                message.messageStatus = 2
                message.timestampDelivered = now
                message.saveFire(withCompletionBlock: nil)
                
                let msg = MessageToPush()
                msg.chatRoomId = message.chatRoomId
                msg.messageId = message.messageId
                msg.saveFire()
            })
            
            self.inputTextField.text = nil
        }
    }
    
    @objc private func handleAttachMedia() {
        let imagePicker = PickMediaViewController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func reloadData(_ scrollToLast: Bool = false) {
        if firMessageObserver!.messages.count >= 20 {
            setupRefreshControl()
        }
        collectionView?.reloadData()
        let contentSize = collectionView?.collectionViewLayout.collectionViewContentSize
        let heightContent = contentSize!.height + 60
        collectionViewHeightAnchor.constant = min(heightContent, view.frame.height)
        collectionView?.layoutIfNeeded()
        if scrollToLast {
            scrollToLastItem()
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.firMessageObserver?.messages.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: ChatMessageCell
        
        let message = self.firMessageObserver!.messages[indexPath.row]
        
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellOutgoing, for: indexPath) as! OutgoingMessageCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIncoming, for: indexPath) as! IncomingMessageCell
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        cell.timestampLabel.text = formatter.string(from: Date(timeIntervalSince1970: Double(exactly: message.timestamp!)!))
        cell.viewWidthAnchor.constant = 190
        if let text = message.text {
            cell.textLabel.text = text
            let size = estimateFrame(forText: text)
            let width = size.width + 70
            cell.viewWidthAnchor.constant = width
        } else {
            cell.textLabel.text = nil
        }
        
        if let image = self.firMessageObserver?.imageCache.object(forKey: message.messageId as AnyObject) as? UIImage {
            cell.attachImage(image: image)
        }
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    
    func estimateFrame(forText text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let messageText = self.firMessageObserver?.messages[indexPath.row].text {
            let size = estimateFrame(forText: messageText)
            let height = size.height + 35
            return CGSize(width: self.view.frame.width, height: height)
        } else {
            return CGSize(width: self.view.frame.width, height: 200)
        }
    }
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.handleSend()
        return true
    }
}

extension ChatLogController: FIRMessageObserverDelegate {
    func message(didRecieveNewMessage message: Message) {
        
        if self.currentChatRoomId != message.chatRoomId { return }
        
        if let status = message.status {
            if (status != .isRead && message.fromId != Auth.auth().currentUser?.uid) {
                message.status = .isRead
                message.saveFire(withCompletionBlock: nil)
            }
        }
        
        self.reloadData(true)
    }
    
    func message(didUpdateMessage message: Message, forIndex index: Int) {
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            })
        }
    }
    
    func message(didRecievePreviousMessages messages: [Message]) {
        self.collectionView?.refreshControl?.endRefreshing()
        if self.firMessageObserver!.messages.isEmpty {
            return
        }
        self.reloadData()
        
    }
}

extension ChatLogController: FIRNetworkStatusDelegate {
    func firDidConnected() {
        self.login()
        self.firMessageObserver?.start()
        self.firMessageObserver?.updateMessages()
        
    }
    
    func firDidDisconnected() {
        print("Disconnected")
    }
}

extension ChatLogController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let ref = Storage.storage().reference()
            let imagesRef = ref.child(currentChatRoomId!).child("images")
            
            let imageName = "\(String(Date().timeIntervalSince1970)).jpg"
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let imageRef = imagesRef.child(imageName)
            
            let message = Message()
            message.fromId = Auth.auth().currentUser?.uid
            message.chatRoomId = currentChatRoomId
            
            firMessageObserver?.sendMessage(message: message, completionHandler: {[weak self] (error, ref) in
                self?.firMessageObserver?.imageCache.setObject(image, forKey: ref.key as AnyObject)
                imageRef.putData(image.jpegData(compressionQuality: 1)!, metadata: metaData) {(meta, error) in
                    if error != nil {
                        return
                    }
                    ref.updateChildValues(["pathToImage": imageRef.fullPath])
                }
            })
            
        }
    }
}
