//
//  ProductsCatalog.swift
//  ankportal
//
//  Created by Admin on 20/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class ProductsCatalog {
    
    private var requestCallbacksById: [Int: [RequestProductByIdCallback]] = [:]
    private let queueREST = RESTRequestsQueue()
    
    public func getBy(id: Int,_ callback: @escaping RequestProductByIdCallback) {
        if let product = getFromCacheBy(id: id) {
            callback(product)
            return
        }
        addRequest(forId: id, callback)
        execute()
    }
    
    private func getFromCacheBy(id: Int) -> Product? {
        let product = productsCache.object(forKey: id as AnyObject) as? Product
        return product
    }
    
    private func addRequest(forId id: Int,_ callback: @escaping RequestProductByIdCallback) {
        if var callbacks = requestCallbacksById[id], !callbacks.isEmpty {
            callbacks.insert(callback, at: 0)
        } else {
            requestCallbacksById[id] = [callback]
        }
    }
    
    private func execute() {
        var requestsById = requestCallbacksById
        requestsById.keys.forEach { (id) in
            let restRequest = prepareRESTService(forProductId: id)
            while let callback = requestsById[id]?.popLast() {
                queueREST.add(request: restRequest, completion: { (data, response, error) in
                    if (error != nil) {
                        print(error as Any)
                        callback(nil)
                        return
                    }
                    if let product = try? JSONDecoder().decode(Product.self, from: data!) {
                        productsCache.setObject(product as AnyObject, forKey: id as AnyObject)
                        callback(product)
                    }
                })
            }
            requestCallbacksById[id] = nil
        }
    }
    
    private func prepareRESTService(forProductId id: Int) -> ANKRESTService {
        let ankRESTService = ANKRESTService(type: .productDetail)
        let restParameterProductId = RESTParameter(filter: .id, value: "\(id)")
        ankRESTService.add(parameter: restParameterProductId)
        return ankRESTService
    }
}
