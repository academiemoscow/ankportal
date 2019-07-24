//
//  RESTPool.swift
//  ankportal
//
//  Created by Admin on 30/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class RESTRequestsQueue {
    
    private var requests: [RESTService] = []
    private var requestsCallbacks: [URLSessionCallback?] = []
    private var isBusy = false
    private var currentRequest: RESTService?
    
    private let concurrentQueue = DispatchQueue(label: "restQueue", qos: .utility, attributes: .concurrent)
    
    public func add(request: RESTService) {
        requests.insert(request, at: 0)
        requestsCallbacks.insert(nil, at: 0)
        execute()
    }
    
    public func add(request: RESTService, completion: @escaping (URLSessionCallback)) {
        requests.insert(request, at: 0)
        requestsCallbacks.insert(completion, at: 0)
        execute()
    }
    
    private func execute() {
        guard isBusy == false else { return }
        
        if let request = requests.popLast() {
            currentRequest = request
            isBusy = true
            let callback = requestsCallbacks.popLast()
            currentRequest?.execute {[weak self] (data, response, error) in
                self?.isBusy = false
                callback??(data, response, error)
                
                self?.execute()
            }
        }
    }
}
