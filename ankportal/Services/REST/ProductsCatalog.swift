//
//  ProductsCatalog.swift
//  ankportal
//
//  Created by Admin on 20/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

typealias RequestProductByIdCallback = (Product?) -> ()

class ProductsCatalog {
    
    private var requestCallbacksById: [Int: [RequestProductByIdCallback]] = [:]
    private let queueREST = RESTRequestsQueue()
    
    public func getBy(id: Int,_ callback: @escaping RequestProductByIdCallback) {
        if let product = getFromCacheBy(id: id) {
            callback(product)
            return
        }
        appendRequest(forId: id, callback)
    }
    
    private func getFromCacheBy(id: Int) -> Product? {
        let product = productsCache.object(forKey: id as AnyObject) as? Product
        return product
    }
    
    private func appendRequest(forId id: Int,_ callback: @escaping RequestProductByIdCallback) {
        if var callbacks = requestCallbacksById[id] {
            callbacks.insert(callback, at: 0)
        } else {
            requestCallbacksById[id] = [callback]
        }
        execute()
    }
    
    private func execute() {
        requestCallbacksById.keys.forEach { (id) in
            while let callback = requestCallbacksById[id]?.popLast() {
                let rest = prepareRESTService(forProductId: id)
                queueREST.add(request: rest, completion: { (data, response, error) in
                    if let products = try? JSONDecoder().decode([Product].self, from: data!) {
                        if let product = products.first {
                            productsCache.setObject(product as AnyObject, forKey: id as AnyObject)
                        }
                        callback(products.first)
                    }
                })
            }
        }
    }
    
    private func prepareRESTService(forProductId id: Int) -> ANKRESTService {
        let ankRESTService = ANKRESTService(type: .productDetail)
        let restParameterProductId = RESTParameter(filter: .id, value: "\(id)")
        ankRESTService.add(parameter: restParameterProductId)
        return ankRESTService
    }
}
