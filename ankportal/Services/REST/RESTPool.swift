//
//  RESTPool.swift
//  ankportal
//
//  Created by Admin on 30/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class RESTPool {
    
    private var requests: [RESTService] = []
    private var requestsCallbacks: [URLSessionCallback?] = []
    private var completionCallback: (() -> ())?
    
    public func add(request: RESTService) {
        self.requests.append(request)
        self.requestsCallbacks.append(nil)
    }
    
    public func add(request: RESTService, completion: @escaping (URLSessionCallback)) {
        self.requests.append(request)
        self.requestsCallbacks.append(completion)
    }
    
    public func execute(callback: @escaping () -> ()) {
        completionCallback = callback
        execute()
    }
    
    private func execute() {
        for (index, request) in requests.enumerated() {
            request.execute {[weak self] (data, response, error) in
                let callback = self?.requestsCallbacks[index]
                callback?(data, response, error)
                
                self?.requestsCallbacks.remove(at: index)
                self?.requests.remove(at: index)
                
                self?.checkAndRunCompleteHandler()
            }
        }
    }
    
    private func checkAndRunCompleteHandler() {
        if ( requests.isEmpty ) {
            completionCallback?()
        }
    }
}
