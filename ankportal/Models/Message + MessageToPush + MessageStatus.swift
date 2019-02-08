//
//  MessageModel.swift
//  ankportal
//
//  Created by Admin on 22/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import Firebase

enum MessageStatus: Int {
    case isSending = 1
    case isSent = 2
    case isRead = 3
}

enum MessageType {
    case Text
    case Media
}

class MessageToPush {
    var messageId: String?
    var chatRoomId: String?
    
    func saveFire() {
        let ref = Database.database().reference().child("messages-push")
        let data = [
            "messageId" : self.messageId!,
            "chatRoomId": self.chatRoomId!
        ] as [String : Any]
        
        let messageRef = ref.childByAutoId()
        messageRef.updateChildValues(data)
    }
}

class Message: NSObject {
    
    @objc var fromId: String?
    @objc var toId: String?
    @objc var text: String?
    @objc var chatRoomId: String?
    @objc var timestamp: NSNumber?
    @objc var timestampDelivered: NSNumber?
    @objc var messageId: String?
    @objc var messageStatus: NSNumber? = 1
    @objc var pathToImage: String?
    
    var messageType: MessageType? = .Text
    
    var image: UIImage?
    
    var onStatusChanged: ((MessageStatus) -> ())? {
        didSet {
            self.onStatusChanged?(self.status!)
        }
    }
   var status: MessageStatus? = .isSending {
        didSet {
            self.messageStatus = NSNumber(value: self.status!.rawValue)
            self.onStatusChanged?(status!)
        }
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        super.setValuesForKeys(keyedValues)
        if let status = keyedValues["messageStatus"] as? Int {
            self.status = MessageStatus(rawValue: status)
        }
        if pathToImage != nil {
            messageType = .Media
        }
    }
    
    func getMessageId() -> String? {
        if let messageId = self.messageId {
            return messageId
        }
        let ref = Database.database().reference().child("messages")
        messageId = ref.childByAutoId().key
        return messageId
    }
    
    func saveFire(withCompletionBlock block: ((Error?, DatabaseReference) -> ())?) {
        
        let ref = Database.database().reference().child("messages")
        ref.keepSynced(true)
        var child: DatabaseReference
        if let roomId = self.chatRoomId {
            child = ref.child(roomId)
        } else {
            child = ref.childByAutoId()
            self.chatRoomId = child.key
        }
        
        var messageRef: DatabaseReference
        if let messageId = self.messageId {
            messageRef = child.child(messageId)
        } else {
            messageRef = child.childByAutoId()
            self.messageId = messageRef.key
        }
        
        if self.timestamp == nil {
            self.timestamp = NSNumber.intervalSince1970()
        }
        
        let message = self.dictionaryWithValues(forKeys: ["fromId", "toId", "text", "chatRoomId", "timestamp", "timestampDelivered", "messageId", "messageStatus", "pathToImage"])
        
        if let block = block {
            messageRef.updateChildValues(message, withCompletionBlock: block)
        } else {
            messageRef.updateChildValues(message)
        }
        
    }
}
