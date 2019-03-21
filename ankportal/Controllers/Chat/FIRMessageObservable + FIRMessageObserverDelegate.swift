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
    @objc optional func message(didUpdateMessage message: Message, forIndex index: Int)
    @objc optional func message(didRecievePreviousMessages messages: [Message])
}

class FIRMessageObservable {
    
    
    var downloadingTask: [String: StorageDownloadTask] = [:]
    
    private var observers: [FIRMessageObserverDelegate] = [FIRMessageObserverDelegate]()
    var messages: [Message] = [Message]()
    
    var firstMessageRecieveCallback: ((Message) -> Void)?
    
    var isObserving: Bool = false
    
    var unreadCount: Int {
        if !self.isObserving { return 0 }
        return messages.filter { $0.status != .isRead && $0.fromId != Auth.auth().currentUser!.uid}.count
    }
    
    var reference: DatabaseReference
    var roomId: String
    
    init(onChatRoomId roomId: String) {
        reference = Database.database().reference().child("messages")
        self.roomId = roomId
    }
    
    func start() {
        if !self.isObserving {
            self.observing()
        }
    }
    
    var keepLoadingMedia: Bool = true
    let mediaLoaderTask = DispatchQueue.global(qos: .utility)
    
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
       // startMediaLoader()
    }
    
    func startMediaLoader() {
        mediaLoaderTask.async {[weak self] in
            while self!.keepLoadingMedia {
                for message in self!.messages {
                    if self?.downloadingTask[message.messageId!] == nil {
                        self!.loadMedia(message: message)
                    }
                }
            }
        }
    }
    
    private func observeHandleChildAdded(snapshot: DataSnapshot) {
        if let dictionary = snapshot.value as? [String: AnyObject] {
            
            let message = Message()
            message.setValuesForKeys(dictionary)
            
            self.firstMessageRecieveCallback?(message)
            self.firstMessageRecieveCallback = nil
            
            //This is service message, not for show
            if message.text == message.fromId { return }
            if let index = self.messages.map({ $0.messageId }).firstIndex(of: message.messageId) {
                messages[index] = message
                for observer in self.observers {
                    observer.message?(didUpdateMessage: message, forIndex: index)
                }
            } else {
                self.messages.append(message)
                for observer in self.observers {
                    observer.message?(didRecieveNewMessage: message)
                }
            }
            
            self.loadMedia(message: message)
        }
    }
    
    private func loadMedia(message: Message) {
        if let pathToImage = message.pathToImage {
            if let _ = imageCache.object(forKey: message.messageId as AnyObject) as? UIImage {
                return
            }
            if let _ = downloadingTask[message.messageId!] {
                return
            }
            
            let task = firImageProvider.getImage(forReference: pathToImage) {[weak self] (image, error) in
                    if error != nil {
                        return
                    }
                    if ( image != nil ) {
                        if let index = self!.messages.map({ $0.messageId }).firstIndex(of: message.messageId) {
                            for observer in self!.observers {
                                observer.message?(didUpdateMessage: message, forIndex: index)
                            }
                        }
                    }
                }
            downloadingTask[message.messageId!] = task
            task.observe(.success) { (_) in
                self.downloadingTask[message.messageId!] = nil
            }
        }
    }
    
    private func observeHandleChildChanged(snapshot: DataSnapshot) {
        if let dictionary = snapshot.value as? [String: AnyObject] {
            
            let message = Message()
            message.setValuesForKeys(dictionary)
            if let index = self.messages.map({ $0.messageId }).firstIndex(of: message.messageId) {
                self.messages[index] = message
                
                for observer in self.observers {
                    observer.message?(didUpdateMessage: message, forIndex: index)
                }
                
                self.loadMedia(message: message)
            }
            
        }
    }
    
    func getPreviousMessages() {
        
        if self.messages.count == 0 { return }
        
        self.reference.child(self.roomId)
            .queryOrdered(byChild: "timestamp")
            .queryEnding(atValue: self.messages.first!.timestamp)
            .queryLimited(toLast: 10)
            .observeSingleEvent(of: .value) { [weak self] (snapshot) in

                var recievedMessages: [Message] = [Message]()
                if let values = (snapshot.value as? [String: AnyObject])?.values {
                    for value in values {
                        let message = Message()
                        
                        message.setValuesForKeys(value as! [String: AnyObject])
                        if message.timestamp != self?.messages.first!.timestamp &&
                           message.text != message.fromId {
                            recievedMessages.append(message)
                        }
                    }
                    
                    recievedMessages.sort(by: { Double(exactly: $0.timestamp!)! < Double(exactly: $1.timestamp!)! })
                    self?.messages = recievedMessages + self!.messages
                    for observer in self!.observers {
                        observer.message?(didRecievePreviousMessages: recievedMessages)
                    }
                    for recievedMessage in recievedMessages {
                        self?.loadMedia(message: recievedMessage)
                    }
                }
                
        }
    }
    
    
    func updateMessages() {
        
        self.messages.filter({ $0.timestampDelivered == nil && $0.fromId == Auth.auth().currentUser?.uid }).forEach { (message) in
            
            message.timestampDelivered = NSNumber.intervalSince1970()
            message.saveFire(withCompletionBlock: nil)
            
        }
        
    }
    
    func sendMessage(message: Message, completionHandler: ((Error?, DatabaseReference) -> ())?) {
        message.saveFire(withCompletionBlock: completionHandler)
        self.messages.append(message)
        
        for observer in self.observers {
            observer.message?(didRecieveNewMessage: message)
        }
    }
    
    func addObserver(_ observer: FIRMessageObserverDelegate) {
        self.observers.append(observer)
    }
    
    func removeObserver(_ observer: FIRMessageObserverDelegate) {
        self.observers = self.observers.filter { $0 !== observer }
    }
}
