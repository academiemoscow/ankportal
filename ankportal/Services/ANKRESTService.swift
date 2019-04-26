//
//  ANKRESTService.swift
//  ankportal
//
//  Created by Admin on 26/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class RESTParameter {
    
    private var name: String
    private var value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    func serialize() -> String {
        return "&\(name)=\(value)"
    }
    
}

enum ANKRESTServiceType: String {
    case productDetail = "productdetail"
    case productList = "productlist"
}

class ANKRESTService {
    
    private let serviceURL = "https://ankportal.ru/rest/index.php?"
    
    private var parametres: [RESTParameter] = []
    private var getType: ANKRESTServiceType
    private var completionCallback: ((Data?, URLResponse?, Error?) -> Void)?
    
    init(type: ANKRESTServiceType) {
        getType = type
    }
    
    public func add(parameter: RESTParameter) {
        parametres.append(parameter)
    }
    
    public func execute(callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionCallback = callback
        if let dataTask = prepareTask() {
            dataTask.resume()
        }
    }
    
    func prepareTask() -> URLSessionTask? {
        guard let url = URL(string: serialize()) else
        { return nil }
        
        return URLSession.shared.dataTask(with: url) { [weak self] (d, r, e) in
            self?.completionHandler(d, r, e)
        }
    }
    
    func completionHandler(_ data: Data?,_ urlresponse: URLResponse?,_ error: Error?) {
        completionCallback?(data, urlresponse, error)
    }
    
    func serialize() -> String {
        var serialized = "\(serviceURL)get=\(getType.rawValue)"
        for parameter in parametres {
            serialized += parameter.serialize()
        }
        return serialized
    }
}
