//
//  FIRMessageObservable + FIRMessageObserverDelegate.swift
//  ankportal
//
//  Created by Admin on 30/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import Firebase

@objc protocol FIRMessageObserverDelegate: class {
    @objc optional func message(didRecieveNewMessage message: Message)
    @objc optional func message(didUpdateMessage message: Message)
    @objc optional func message(didRecievePreviousMessages messages: [Message])
}

class FIRMessageObservable {
    
    private var observers: [FIRMessageObserverDelegate] = [FIRMessageObserverDelegate]()
    var messages: [Message] = [Message]()
    
    var isObserving: Bool = false
    
    var unreadCount: Int {
        if !self.isObserving { return 0 }
        return messages.filter { $0.status != .isRead && $0.fromId != Auth.auth().currentUser!.uid}.count
    }
    
    var reference: DatabaseReference
    var roomId: String
    
    init(onChatRoomId roomId: String) {
        Database.database().isPersistenceEnabled = true
        reference = Database.database().reference().child("messages")
        self.roomId = roomId
    }
    
    func start() {
        if self.isObserving { return }
        self.observing()
    }
    
    private func observing() {
        self.reference
            .child(self.roomId)
            .queryOrdered(byChild: "timestamp").queryLimited(toLast: 20)
            .observe(.childAdded, with: self.observeHandleChildAdded)
        
        self.reference
            .child(self.roomId)
            .queryOrdered(byChild: "timestamp")
            .observe(.childChanged, with: self.observeHandleChildChanged)
        
        self.isObserving = true
    }
    
    private func observeHandleChildAdded(snapshot: DataSnapshot) {
        if let dictionary = snapshot.value as? [String: AnyObject] {
            
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.insert(message, at: 0)
            
                for observer in self.observers {
                    observer.message?(didRecieveNewMessage: message)
                }
            
        }
    }
    
    private func observeHandleChildChanged(snapshot: DataSnapshot) {
        if let dictionary = snapshot.value as? [String: AnyObject] {
            
            let message = Message()
            message.setValuesForKeys(dictionary)
            if let index = self.messages.map({ $0.messageId }).firstIndex(of: message.messageId) {
                self.messages[index] = message
                
                self.updateMessages()
                
                for observer in self.observers {
                    observer.message?(didUpdateMessage: message)
                }
            }
            
        }
    }
    
    func getPreviousMessages() {
        
        if self.messages.count == 0 { return }
        
        self.reference.child(self.roomId)
            .queryOrdered(byChild: "timestamp")
            .queryEnding(atValue: self.messages.last!.timestamp)
            .queryLimited(toLast: 10)
            .observeSingleEvent(of: .value) { [weak self] (snapshot) in
                
                var recievedMessages: [Message] = [Message]()
                if let values = (snapshot.value as? [String: AnyObject])?.values {
                    for value in values {
                        let message = Message()
                        message.setValuesForKeys(value as! [String: AnyObject])
                        if message.timestamp != self?.messages[0].timestamp {
                            recievedMessages.insert(message, at: 0)
                        }
                    }
                    
                    recievedMessages.sort(by: { Double(exactly: $0.timestamp!)! < Double(exactly: $1.timestamp!)! })
                    self?.messages = recievedMessages + self!.messages
                    for observer in self!.observers {
                        observer.message?(didRecievePreviousMessages: recievedMessages)
                    }
                }
                
        }
    }
    
    
    func updateMessages() {
        
        self.messages.filter({ $0.timestampDelivered == nil && $0.fromId == Auth.auth().currentUser?.uid }).forEach { (message) in
            
            message.messageStatus = 2
            message.timestampDelivered = NSNumber.intervalSince1970()
            message.saveFire(withCompletionBlock: nil)
            
        }
        
    }
    
    func addObserver(_ observer: FIRMessageObserverDelegate) {
        self.observers.append(observer)
    }
    
    func removeObserver(_ observer: FIRMessageObserverDelegate) {
        self.observers = self.observers.filter { $0 !== observer }
    }
}
