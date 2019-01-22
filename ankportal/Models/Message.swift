//
//  MessageModel.swift
//  ankportal
//
//  Created by Admin on 22/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    
    var userFrom: [String:String]?
    var userTo: [String:String]?
    var messageText: String?
    var chatRoomId: String?
    
    mutating func saveFire(withCompletionBlock block: ((Error?, DatabaseReference) -> ())?) {
        
        if let text = self.messageText {
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
            
            var message = [
                "text"      :   text,
                "fromId"    :   Auth.auth().currentUser!.uid,
                "timestamp" :   Int(Date().timeIntervalSince1970)
                ] as [String : Any]
            
            if userTo != nil {
                if let toId = userTo!["uid"] {
                    message["toId"] = toId
                }
            }
            
            if let block = block {
                messageRef.updateChildValues(message, withCompletionBlock: block)
            } else {
                
                messageRef.updateChildValues(message)
            }
        }
        
    }
}
