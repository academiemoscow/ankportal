//
//  FIRMessageObservable + FIRMessageObserverDelegate.swift
//  ankportal
//
//  Created by Admin on 30/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import Firebase

@objc protocol FIRMessageObserverDelegate {
    @objc optional func message(didRecieveNewMessage message: Message)
    @objc optional func message(didUpdateMessage message: Message)
}

class FIRMessageObservable {
    
    var observers: [FIRMessageObserverDelegate] = [FIRMessageObserverDelegate]()
    var messages: [Message] = [Message]()
    
    var isObserving: Bool = false
    
    var currentFirebaseUserId: String? {
        didSet {
            self.observing()
        }
    }
    
    var unreadCount: Int {
        return messages.filter { $0.status != .isRead }.count
    }
    
    var reference: DatabaseReference
    
    static let instance = FIRMessageObservable()
    
    private init() {
        Database.database().isPersistenceEnabled = true
        reference = Database.database().reference().child("userid-messageid")
    }
    
    func start() {
        if self.isObserving { return }
        if let currentUser = UserDefaults.standard.object(forKey: "CurrentUser") as? [String: String] {
            Auth.auth().signIn(withEmail: currentUser["userEmail"]!, password: currentUser["userPass"]!) { (authResult, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                if let uid = Auth.auth().currentUser?.uid {
                    self.currentFirebaseUserId = uid
                }
            }
        }
    }
    
    private func observing() {
        if let userId = currentFirebaseUserId {
            self.reference
                .child(userId)
                .queryOrdered(byChild: "timestamp").queryLimited(toLast: 20)
                .observe(.childAdded, with: self.observeHandleChildAdded)
            
            self.reference
                .child(userId)
                .queryOrdered(byChild: "timestamp")
                .observe(.childChanged, with: self.observeHandleChildChanged)
            
            self.isObserving = true
        }
    }
    
    private func observeHandleChildAdded(snapshot: DataSnapshot) {
        if let dictionary = snapshot.value as? [String: AnyObject] {
            
                let ref = Database.database().reference().child("messages")
                    .child(dictionary["chatRoomId"] as! String)
                    .child(snapshot.key)
            
                ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                    if let valueDict = snapshot.value as? [String: AnyObject] {
                        let message = Message()
                        message.setValuesForKeys(valueDict)
                        
                        message.status = MessageStatus(rawValue: valueDict["messageStatus"] as! Int)
                        self?.messages.append(message)
                        
                        for observer in self!.observers {
                            observer.message?(didRecieveNewMessage: message)
                        }
                    }
                }
            
        }
    }
    
    
    private func observeHandleChildChanged(snapshot: DataSnapshot) {
        if let dictionary = snapshot.value as? [String: AnyObject] {
            
            let ref = Database.database().reference().child("messages")
                .child(dictionary["chatRoomId"] as! String)
                .child(snapshot.key)
            
            ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                if let valueDict = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.setValuesForKeys(valueDict)
                    message.status = MessageStatus(rawValue: valueDict["messageStatus"] as! Int)
                    
                    if let index = self?.messages.map({ $0.messageId }).firstIndex(of: message.messageId) {
                        self?.messages[index] = message
                    }
                    
                    for observer in self!.observers {
                        observer.message?(didUpdateMessage: message)
                    }
                }
            }
            
        }
    }
    
    func addObserver(_ observer: FIRMessageObserverDelegate) -> FIRMessageObservable {
        self.observers.append(observer)
        for message in self.messages {
            observer.message?(didRecieveNewMessage: message)
        }
        return self
    }
    
    func removeObserver(_ observer: FIRMessageObserverDelegate) -> FIRMessageObservable {
        self.observers = self.observers.filter { $0 !== observer }
        return self
    }
}
