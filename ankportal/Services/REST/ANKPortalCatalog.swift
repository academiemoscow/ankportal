//
//  ANKPortalCatalog.swift
//  ankportal
//
//  Created by Admin on 07/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

typealias ANKPortalCatalogRequestCallback = ([ANKPortalItemSelectable], Error?) -> ()

class ANKPortalCatalogs {
    
    static let brands = ANKPortalCatalog(restServiceType: .brandList)
    static let groups = ANKPortalCatalog(restServiceType: .groupList)
    static let sections = ANKPortalCatalog(restServiceType: .productSections)
 
    static func desellectAll() {
        brands.desellectAll()
        groups.desellectAll()
        sections.desellectAll()
    }
}

class ANKPortalCatalog {
    
    private var status: RESTStatus = .new {
        didSet {
            executeCallbacks()
        }
    }
    
    private var error: Error?
    
    private let ankrestServiceQueue: RESTRequestsQueue = RESTRequestsQueue()
    private let ankrestServiceType: ANKRESTServiceType
    
    private var catalogItems: [ANKPortalItemSelectable] = []
    
    private var requestCallbacksById: [String: [ANKPortalCatalogRequestCallback]] = [:]
    private var requestCallbacks: [ANKPortalCatalogRequestCallback] = []
    
    private var executesCounter = 0 {
        didSet {
            guard oldValue < executesCounter else {
                return
            }
            executeCallbacks()
        }
    }
    
    private var executingFlag = false
    
    var selectedItems: [ANKPortalItemSelectable] {
        get {
            return catalogItems.filter({ $0.isSelected })
        }
    }
    
    init(restServiceType: ANKRESTServiceType) {
        self.ankrestServiceType = restServiceType
        loadCatalog()
    }
    
    private func loadCatalog() {
        let ankrestService = ANKRESTService(type: ankrestServiceType)
        ankrestServiceQueue.add(request: ankrestService) { [weak self] (data, response, error) in
            if let error = error {
                self?.error = error
                self?.loadCatalog()
                self?.status = .error
                return
            }
            self?.error = nil
            if let data = try? JSONDecoder().decode([ANKPortalItemSelectable].self, from: data!) {
                self?.catalogItems = data
            }
            self?.status = .complete
        }
    }
    
    public func desellectAll() {
        catalogItems.forEach({ $0.isSelected = false })
    }
    
    public func get(byID id: String, _ callback: @escaping ANKPortalCatalogRequestCallback) {
        if var callbacks = requestCallbacksById[id] {
            callbacks.append(callback)
            requestCallbacksById[id] = callbacks
        } else {
            requestCallbacksById[id] = [callback]
        }
        executesCounter += 1
    }
    
    public func getAll(_ callback: @escaping ANKPortalCatalogRequestCallback) {
        requestCallbacks.append(callback)
        executesCounter += 1
    }
    
    private func executeCallbacks() {
        guard status != .new, executesCounter > 0, executingFlag == false else {
            return
        }
        
        executingFlag = true
        executesCounter -= 1
        
        while let callback = requestCallbacks.popLast() {
            callback(catalogItems, error)
        }
        requestCallbacksById.keys.forEach({ executeCallbackFind(byID: $0, callbacks: requestCallbacksById[$0]!) })
        
        executingFlag = false
        executeCallbacks()
    }
    
    private func executeCallbackFind(byID id: String, callbacks: [ANKPortalCatalogRequestCallback]) {
        var result: [ANKPortalItemSelectable] = []
        if let findingItem = catalogItems.filter({ $0.id == id }).first {
            result.append(findingItem)
        }
        while let callback = requestCallbacksById[id]?.popLast() {
            callback(result, error)
        }
    }
}
