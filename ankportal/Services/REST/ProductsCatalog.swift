//
//  ProductsCatalog.swift
//  ankportal
//
//  Created by Admin on 20/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class ProductsCatalog {
    
    private let restParameterProductId = RESTParameter(filter: .id, value: "")
    
    lazy private var productREST: ANKRESTService = {
        let ankRESTService = ANKRESTService(type: .productDetail)
        ankRESTService.add(parameter: restParameterProductId)
        return ankRESTService
    }()
    
    public func getBy(id: Int,_ callback: @escaping (Product?) -> ()) {
        if let product = getFromCacheBy(id: id) {
            callback(product)
            return
        }
        
        restParameterProductId.set(value: id)
        productREST.execute { (data, response, error) in
            if let products = try? JSONDecoder().decode([Product].self, from: data!) {
                if let product = products.first {
                    productsCache.setObject(product as AnyObject, forKey: id as AnyObject)
                }
                callback(products.first)
            }
        }
    }
    
    private func getFromCacheBy(id: Int) -> Product? {
        let product = productsCache.object(forKey: id as AnyObject) as? Product
        return product
    }
}
