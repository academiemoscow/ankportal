//
//  ANKRESTService.swift
//  ankportal
//
//  Created by Admin on 26/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

typealias URLSessionCallback = (Data?, URLResponse?, Error?) -> Void

enum ANKRESTServiceType: String {
    case bannersInfo = "banerlist"
    case productDetail = "productdetail"
    case productList = "productlist"
    case productSections = "productsections"
    case educationList = "seminarlist"
    case seminarDetail = "seminardetail"
    case brandList = "brandlist"
    case groupList = "grouplist"
}

class ANKRESTService: RESTService {
    
    private var parameters: [RESTParameter] = []
    private var getType: ANKRESTServiceType
    private var completionCallback: ((Data?, URLResponse?, Error?) -> Void)?
    
    private var isPersistent: Bool = false
    private var maxAttempsCount: Int = 5
    private var attempts: Int = 0
    
    private var restStatus: RESTStatus = .new
    
    var url: URL? {
        get {
            return URL(string: serialize())
        }
    }
    
    var serviceURL: String {
        get {
            return "https://ankportal.ru/rest/index2.php?"
        }
    }
    
    init(type: ANKRESTServiceType) {
        getType = type
    }
    
    convenience init(type: ANKRESTServiceType, completion: @escaping URLSessionCallback) {
        self.init(type: type)
        completionCallback = completion
    }
    
    convenience init(type: ANKRESTServiceType, parameters: [RESTParameter]) {
        self.init(type: type)
        add(parameters: parameters)
    }
    
    public func set(isPersistent: Bool, maxAttempts: Int) {
        self.isPersistent = isPersistent
        self.maxAttempsCount = maxAttempts
    }
    
    public func add(parameters: [RESTParameter]) {
        for parameter in parameters {
            add(parameter: parameter)
        }
    }
    
    public func add(parameter: RESTParameter) {
        checkForMultichoice(withNewParameter: parameter)
        parameters.append(parameter)
    }
    
    private func checkForMultichoice(withNewParameter parameter: RESTParameter) {
        parameters.forEach({
            if $0.initName == parameter.initName {
                let _ = $0.toArray()
                let _ = parameter.toArray()
            }
        })
    }
    
    public func clearParameters() {
        parameters.removeAll()
    }
    
    public func getRESTStatus() -> RESTStatus {
        return restStatus
    }
    
    public func execute(withParametres parameters: [RESTParameter], callback: @escaping URLSessionCallback) {
        clearParameters()
        add(parameters: parameters)
        execute(callback: callback)
    }
    
    public func execute(callback: @escaping URLSessionCallback) {
        attempts = 0
        completionCallback = callback
        execute()
    }
    
    public func execute() {
        if let dataTask = prepareTask() {
            dataTask.resume()
        }
    }
    
    func prepareTask() -> URLSessionTask? {
        guard let url = URL(string: serialize()) else
        { return nil }
        
        return URLSession.shared.dataTask(with: url) {[weak self] (d, r, e) in
            guard let context = self else
            { return }
            
            context.attempts += 1
            if (e != nil) {
                context.restStatus = .error
                if (context.isPersistent &&  context.attempts < context.maxAttempsCount) {
                    context.execute()
                    return
                }
            }
            
            context.completionHandler(d, r, e)
        }
    }
    
    func completionHandler(_ data: Data?,_ urlresponse: URLResponse?,_ error: Error?) {
        restStatus = .complete
        completionCallback?(data, urlresponse, error)
        completionCallback = nil
    }
    
    func serialize() -> String {
        var serialized = "\(serviceURL)get=\(getType.rawValue)"
        for parameter in parameters {
            serialized += parameter.serialize()
        }
        return serialized.encodeURL
    }
    
}
