//
//  FIRNetworkStatus+FIRNetworkStatusDelegate.swift
//  ankportal
//
//  Created by Admin on 01/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import Firebase

@objc protocol FIRNetworkStatusDelegate: class {
    @objc optional func firDidConnected()
    @objc optional func firDidDisconnected()
}

let NetworkStatus = FIRNetworkStatus()

class FIRNetworkStatus {
    
    enum Status {
        case online
        case offline
    }
    
    private var observers: [FIRNetworkStatusDelegate] = [FIRNetworkStatusDelegate]()
    
    var status: Status = Status.offline
    
    fileprivate init() {
        setupObserving()
    }
    
    private func setupObserving() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value) { [weak self] (snapshot) in
            if snapshot.value as? Bool ?? false {
                self?.status = Status.online
                for observer in self!.observers {
                    observer.firDidConnected?()
                }
                
            } else {
                self?.status = Status.offline
                for observer in self!.observers {
                    observer.firDidDisconnected?()
                }
            }
        }
    }
    
    func addObserver(_ observer: FIRNetworkStatusDelegate) {
        self.observers.append(observer)
    }
    
    func removeObserver(_ observer: FIRNetworkStatusDelegate) {
        self.observers = self.observers.filter { $0 !== observer }
    }
}

