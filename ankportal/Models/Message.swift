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
    
    var messageId: String?
    var status: MessageStatus = .isSent
    
    func saveFire(withCompletionBlock block: ((Error?, DatabaseReference) -> ())?) {
        
        if let text = self.text {
            let ref = Database.database().reference().child("messages")
            ref.keepSynced(true)
            
            var child: DatabaseReference
            if let roomId = self.chatRoomId {
                child = ref.child(roomId)
            } else {
                child = ref.childByAutoId()
                self.chatRoomId = child.key
            }
            
            let messageRef = child.childByAutoId()
            messageId = messageRef.key
            
            self.timestamp = NSNumber(value: Date().timeIntervalSince1970)
            
            var message = [
                "text"      :   text,
                "fromId"    :   Auth.auth().currentUser!.uid,
                "timestamp" :   self.timestamp!,
                "chatRoomId":   self.chatRoomId!
                ] as [String : Any]
            
            if let toId = self.toId {
                message["toId"] = toId
            }
            
            if let block = block {
                messageRef.updateChildValues(message, withCompletionBlock: block)
            } else {
                messageRef.updateChildValues(message)
            }
        }
        
    }
}
