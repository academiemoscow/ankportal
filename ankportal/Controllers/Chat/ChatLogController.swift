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
import AMKeyboardFrameTracker

class ChatLogController: UICollectionViewController {

    enum KeyboardFrameState {
        case moveToShow
        case moveToHide
        case onScreen
        case hidden
    }
    
    private var firstLoadedDone = false
    
    private var keyboardFrameState: KeyboardFrameState = .hidden
    private var keyboardIsHidden = true
    
    private var isLoggedIn = false
    private let cellOutgoing = "CellOutgoing"
    private let cellIncoming = "CellIncoming"
    
    private var refreshingFlag: Bool = false
    private var previousBottomSpacingKeyboardTracker: CGFloat = 0
    private var contentOffsetTranslation: CGFloat = 0
    
    private var keyboardFrame: CGRect = CGRect.zero
    
    var firMessageObserver: FIRMessageObservable?
    
    var currentUser: [String:String]? = UserDefaults.standard.object(forKey: "CurrentUser") as? [String:String]
//    var currentUser: [String:String]? = nil
    var currentChatRoomId: String? = UserDefaults.standard.object(forKey: "CurrentChatRoomId") as? String
//    var currentChatRoomId: String? = "-LWoUee8yUihyL0UnvWJ" //Временно, для тестов
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.color = UIColor.black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        return indicator
    }()
    
    lazy var keyboardFrameTacker: AMKeyboardFrameTrackerView = {
        let frameTracker = AMKeyboardFrameTrackerView(height: inputViewContainerInitialHeight)
        frameTracker.delegate = self
        return frameTracker
    }()
    
    lazy var inputTextField: UITextInputView = {
        let textField = UITextInputView(frame: CGRect(x: 50, y: 50, width: 200, height: 50))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Текст сообщения..."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor(r: 217, g: 217, b: 217).cgColor
        textField.delegate = self
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 2, bottom: 2, right: 2)
        textField.inputAccessoryView = keyboardFrameTacker
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)//type: .system)
//        button.setTitle("Отпр", for: .normal)
        button.setImage(UIImage.init(named: "send_msg_button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var attachMedia: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
//        button.setTitle("+", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        button.setImage(UIImage.init(named: "attach_button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var inputContainerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    lazy var imagePickerVC: PickMediaViewController = {
        let imagePicker = PickMediaViewController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private var inputViewContainerInitialHeight: CGFloat = 50
    
    lazy var inputContainerViewHeightConstraint: NSLayoutConstraint = {
        let constraint =
            inputContainerView.heightAnchor.constraint(equalToConstant: inputViewContainerInitialHeight)
        return constraint
    }()
    
    lazy var separatorInputView: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
//        separator.backgroundColor = UIColor.lightGray
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }()
    
    lazy var inputContainerViewBottomAnchor: NSLayoutConstraint = {
        let constraint = inputContainerView.bottomAnchor.constraint(equalTo: self.safeLayoutGuide.bottomAnchor)
        constraint.isActive = true
        return constraint
    }()
    
    lazy var safeLayoutGuide: UILayoutGuide = {
        return view.safeAreaLayoutGuide
    }()
    
    private var messagesReference: DatabaseReference?
    private var firstLoadComplete: Bool = false
    
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
    
    private let initialTopContentInset: CGFloat = 60
    
    private func setupCollectionView() {
        view.backgroundColor = UIColor.white
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.collectionView?.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        self.collectionView?.register(OutgoingMessageCell.self, forCellWithReuseIdentifier: cellOutgoing)
        self.collectionView?.register(IncomingMessageCell.self, forCellWithReuseIdentifier: cellIncoming)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.keyboardDismissMode = .interactive
        self.collectionView?.contentInset = UIEdgeInsets(top: initialTopContentInset, left: 0, bottom: 0, right: 0)
        self.collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: initialTopContentInset, left: 0, bottom: 0, right: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setupInputComponents() {
        
        view.addSubview(inputContainerView)
        inputContainerViewBottomAnchor.isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: collectionView.widthAnchor).isActive = true
        inputContainerViewHeightConstraint.isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: self.safeLayoutGuide.bottomAnchor, constant: -inputViewContainerInitialHeight - 8).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [attachMedia, inputTextField, sendButton])
        stackView.isBaselineRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = UIColor.black
        stackView.alignment = .center
        
        inputTextField.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: -10).isActive = true
        
        inputContainerView.addSubview(stackView)
        attachMedia.widthAnchor.constraint(equalToConstant: 40).isActive = true
        attachMedia.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.45).isActive = true
        attachMedia.imageView?.contentMode = .scaleAspectFit
        attachMedia.addTarget(self, action: #selector(handleAttachMedia), for: .touchUpInside)
        
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5).isActive = true
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        stackView.leftAnchor.constraint(equalTo: safeLayoutGuide.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: safeLayoutGuide.rightAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor).isActive = true
        
        inputContainerView.addSubview(separatorInputView)
        separatorInputView.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        separatorInputView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        let maskView = UIView()
//        maskView.backgroundColor = inputContainerView.backgroundColor
        maskView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(maskView)
        maskView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        maskView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        maskView.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor).isActive = true
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.keyboardFrameTacker.setHeight(inputViewContainerInitialHeight)
        self.transitioningDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        (UIApplication.shared.delegate as! AppDelegate).chatLogTabBarContentView.setBadge(nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).chatLogTabBarContentView.setBadge(nil)
        
        setupController()
        setupCollectionView()
        setupInputComponents()
        registerKeyboardObservers()
    
        setupNavBar()
        startAnimatingNavBar()
        
        NetworkStatus.addObserver(self)
        
        navigationController?.navigationBar.tintColor = UIColor.black

        let cartBarButtonItem = UIBarButtonItem(customView: UIViewCartIcon())
        navigationItem.rightBarButtonItem = cartBarButtonItem
        
        let logoView = UIBarButtonItem(customView: UILogoImageView())
        navigationItem.leftBarButtonItem = logoView
    }
    

    
    func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(toggleKeyboardIsVisisble), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleKeyboardIsHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func toggleKeyboardIsHidden(notification: Notification) {
        keyboardIsHidden = true
        keyboardFrame = CGRect.zero
    }
    
    @objc func toggleKeyboardIsVisisble(notification: Notification) {
        keyboardIsHidden = false
        setKeyboardFrame(notification)
    }
    
    func setKeyboardFrame(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    }
    
    func setupNavBar() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        let label = UILabel()
        label.font = UIFont.defaultFont(ofSize: 18)
        let middleView = UIStackView(arrangedSubviews: [activityIndicator, label])
        middleView.axis = .horizontal
        middleView.spacing = 8
        navigationItem.titleView = middleView
    }
    
    func startAnimatingNavBar() {
        guard
            let titleView    = navigationItem.titleView as? UIStackView,
            let activityView = titleView.arrangedSubviews[0] as? UIActivityIndicatorView,
            let label        = titleView.arrangedSubviews[1] as? UILabel
            else {
                navigationItem.titleView = nil
                return
        }
        
        activityView.startAnimating()
        label.text = " Подключение..."
    }
    
    func stopAnimatingNavBar() {
        
        if ( !self.firstLoadedDone ) { return }
        
        guard
            let titleView    = navigationItem.titleView as? UIStackView,
            let activityView = titleView.arrangedSubviews[0] as? UIActivityIndicatorView,
            let label        = titleView.arrangedSubviews[1] as? UILabel
        else {
            navigationItem.titleView = nil
            return
        }
        
        activityView.stopAnimating()
        label.text = "В сети"
        
    }
    
    func setupObserver() {
        self.firMessageObserver = FIRMessageObservable(onChatRoomId: currentChatRoomId!)
        self.firMessageObserver?.firstMessageRecieveCallback = { [unowned self]_ in
            self.firstLoadedDone = true
            self.stopAnimatingNavBar()
        }
        self.firMessageObserver?.addObserver(self)
    }
    
    private func login() {
        if ( isLoggedIn ) { return }
        if ( currentUser == nil ) {
            getNewUser()
        } else {
            signInFireBase()
        }
        isLoggedIn = true
    }
    
    func onSuccessLogin() {
        self.isLoggedIn = true
        enterChatRoom()
        setupObserver()
    }
    
    func enterChatRoom() {
        if ( self.currentChatRoomId != nil ) { return }
        
        let ref = Database.database().reference().child("messages")
        self.currentChatRoomId = ref.childByAutoId().key
        UserDefaults.standard.set(self.currentChatRoomId, forKey: "CurrentChatRoomId")
        
        let message = Message()
        message.chatRoomId = self.currentChatRoomId
        message.text = Auth.auth().currentUser?.uid
        message.fromId = Auth.auth().currentUser?.uid
        message.saveFire(withCompletionBlock: nil)
    }
    
    private func getNewUser() {
        let dateReg = String(Date().timeIntervalSince1970)
        let userEmail = "\(dateReg)@ankportal.ru"
        let user = ["userName": dateReg, "userPass": userEmail, "userEmail": userEmail]
        self.signUpFireBase(user: user)
    }
    
    private func signUpFireBase(user: [String:String]) {
        Auth.auth().createUser(withEmail: user["userEmail"]!, password: user["userPass"]!) {[weak self] (authResult, error) in
            if let error = error {
                self?.isLoggedIn = false
                print(error)
                return
            }
            self?.onSuccessLogin()
            
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
    
    private func updateCurrentUser(setName name: String) {
        guard
            let message = self.firMessageObserver?.messages.last,
            message.fromId == "greetings_message"
        else {
            return
        }
        
        let ref =
            Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        let userInfo = [
            "name"  : name,
            "email" : self.currentUser!["userEmail"],
            "type"  : "1"
        ]
        self.currentUser?["name"] = name
        ref.updateChildValues(userInfo as [AnyHashable : Any])
        UserDefaults.standard.set(self.currentUser, forKey: "CurrentUser")
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
                self?.isLoggedIn = false
                print(error)
                return
            }
            self?.onSuccessLogin()
            
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
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc private func handleSend() {
        if let text = inputTextField.text {
            if text.count == 0 { return }
            
            let message = Message()
            message.chatRoomId = self.currentChatRoomId
            message.text = text
            message.fromId = Auth.auth().currentUser?.uid
            
            self.updateCurrentUser(setName: text)
            
            self.firMessageObserver?.sendMessage(message: message, completionHandler: { (error, ref) in
                if let error = error {
                    UIAlertController.displayError(withTitle: "Ошибка", withErrorText: error.localizedDescription, presentIn: self)
                    return
                }
                
                let msg = MessageToPush()
                msg.chatRoomId = message.chatRoomId
                msg.messageId = message.messageId
                msg.saveFire()
            })
            
            self.inputTextField.text = nil
        }
    }
    
    @objc private func handleAttachMedia() {
        present(self.imagePickerVC, animated: false, completion: nil)
    }
    
    func reloadData(_ scrollToLast: Bool = false) {
        if firMessageObserver!.messages.count >= 20 {
            setupRefreshControl()
        }
        
        collectionView?.reloadData()
        calcAndSetCollectionViewInsets()
        
        if scrollToLast {
            scrollToLastItem()
        }
    }
    
    private func scrollToLastItem() {
        if let itemCount = self.firMessageObserver?.messages.count, itemCount > 0 {
            let contentSize = collectionView?.collectionViewLayout.collectionViewContentSize
            let bottomContentOffset = contentSize!.height - collectionView!.bounds.height
            let bottomInset = getBottomInset()
            let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
            let keyboardHeight = keyboardFrame.height == 0 ? 0 : keyboardFrame.height - bottomInset - tabBarHeight
            collectionView.setContentOffset(CGPoint(x: 0, y: bottomContentOffset + keyboardHeight), animated: true)
        }
    }
    
    private func calcAndSetCollectionViewInsets() {
        let contentSize = collectionView?.collectionViewLayout.collectionViewContentSize
    
        let heightContent = contentSize!.height
        let boundsHeight = self.collectionView!.bounds.size.height
        let topContentInset = max(boundsHeight - (heightContent + getBottomInset()), initialTopContentInset)
        collectionView?.contentInset.top = topContentInset
    }
    
    private func getBottomInset() -> CGFloat {
        let safeLayoutBottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return inputViewContainerInitialHeight + 8 + safeLayoutBottomInset
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
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
        
        cell.chatController = self
        
        cell.stopAnimating()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        cell.timestampLabel.text = formatter.string(from: Date(timeIntervalSince1970: Double(exactly: message.timestamp!)!))
        cell.viewWidthAnchor.constant = 190
        if let text = message.text {
            cell.textLabel.text = text
            let size = estimateFrame(forText: text)
            let width = size.width + 30
            cell.viewWidthAnchor.constant = width
        } else {
            cell.startAnimating()
            cell.textLabel.text = nil
        }
        
        if let image = firImageProvider.getImage(forReference: message.pathToImage) {
            cell.stopAnimating()
            cell.attachImage(image: image)
        }
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

}


extension ChatLogController: UICollectionViewDelegateFlowLayout {
    
    func estimateFrame(forText text: String, _ width: CGFloat = 200) -> CGRect {
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let messageText = self.firMessageObserver?.messages[indexPath.row].text {
            let size = estimateFrame(forText: messageText)
            let height = size.height + 45
            return CGSize(width: self.view.frame.width, height: height)
        } else {
            return CGSize(width: self.view.frame.width, height: 200)
        }
    }
}

extension ChatLogController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            self.handleSend()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            checkAndSetPlaceholder(textView)
            let size = estimateFrame(forText: text, textView.frame.width - 14)
            let height = size.height + 25
            var constant: CGFloat
            if height >= inputViewContainerInitialHeight {
                constant = height
            } else {
                constant = inputViewContainerInitialHeight
            }
            inputContainerViewHeightConstraint.constant = constant
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkAndSetPlaceholder(textView)
    }
    
    private func checkAndSetPlaceholder(_ textView: UITextView) {
        if let textView = textView as? UITextInputView {
            textView.updatePlaceholder()
        }
    }
    
    private func clearText(_ textView: UITextView) {
        if let textView = textView as? UITextInputView {
            textView.text = nil
        }
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
        self.firMessageObserver?.updateMessages()
        
        self.stopAnimatingNavBar()
        
    }
    
    func firDidDisconnected() {
        self.startAnimatingNavBar()
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
            message.pathToImage = imageRef.fullPath
            firImageProvider.setImage(forReference: imageRef.fullPath, image: image)
            
            let uploadChatImageBackgroundTask = UIApplication.shared.beginBackgroundTask()
            firMessageObserver?.sendMessage(message: message, completionHandler: {(error, ref) in
                let task = imageRef.putData(image.portraitOriented().jpegData(compressionQuality: 0)!, metadata: metaData) {(meta, error) in
                    if error != nil {
                        return
                    }
                }
                task.observe(.progress, handler: { (snapshot) in
                    print(snapshot)
                })
            })
            UIApplication.shared.endBackgroundTask(uploadChatImageBackgroundTask)
            
        }
    }
}

extension ChatLogController: AMKeyboardFrameTrackerDelegate {
    
    private func resolveKeyboardState(_ traslation: CGFloat, previousState: KeyboardFrameState = .hidden) -> KeyboardFrameState {

        switch traslation {
        case _ where traslation > 0:
            return .moveToShow
        case _ where traslation < 0:
            return .moveToHide
        case 0 where previousState == .moveToHide:
            return .hidden
        case 0 where previousState == .moveToShow:
            return .onScreen
        default:
            return previousState
        }
        
    }
    
    private func calcOffsetContentFor(with frame: CGRect) -> CGFloat {
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let bottomSpacing = view.frame.height - frame.origin.y - tabBarHeight - 1 + safeAreaInsets
        return bottomSpacing > 0 ? -bottomSpacing : 0
    }
    
    func keyboardFrameDidChange(with frame: CGRect) {
        let offset = calcOffsetContentFor(with: frame)
        contentOffsetTranslation = -offset + previousBottomSpacingKeyboardTracker
        inputContainerViewBottomAnchor.constant = offset
//        view.layoutIfNeeded()
        
        let nextKeyboardStatus = resolveKeyboardState(contentOffsetTranslation, previousState: keyboardFrameState)
        
        if ( nextKeyboardStatus == .hidden ) {
            calcAndSetCollectionViewInsets()
        }
        
        if ( nextKeyboardStatus == .moveToShow && keyboardIsHidden ) {
            collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y + contentOffsetTranslation), animated: false)
        }
        
        if ( offset != previousBottomSpacingKeyboardTracker ) {
            previousBottomSpacingKeyboardTracker = offset
            keyboardFrameState = nextKeyboardStatus
        }
    }
}

extension ChatLogController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageZoomAnimationController(animationDuration: 2, animationType: .present)
    }
}
