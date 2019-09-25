//
//  ProductFinder.swift
//  ankportal
//
//  Created by Admin on 24/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class ANKRESTService2: ANKRESTService {
    override var serviceURL: String {
        get {
            return "https://ankportal.ru/rest/index2.php?"
        }
    }
}

protocol ProductFinderDelegate {
    func willFinding(_ finder: ProductFinder)
}

class ProductFinder {
    
    typealias ProductsCallback = (String, [ProductPreview], Error?) -> ()
    
    /** Delay before request in seconds */
    private let delay: TimeInterval = 0.5
    
    private var queryString: String = ""
    
    private var callback: ProductsCallback?
    
    private let restService = ANKRESTService2(type: .productList)
    
    private var timer: Timer?
    
    public var delegate: ProductFinderDelegate?
    
    func find(byString query: String,_ _callback: @escaping ProductsCallback) {
        if (query == queryString || query == "") {
            return
        }
        queryString = query
        callback = _callback
        startCountdown()
    }
    
    private func performSearching() {
        delegate?.willFinding(self)
        let _queryString = queryString
        restService.clearParameters()
        restService.add(parameter: RESTParameter(filter: .searchString, value: _queryString))
        restService.execute {[weak self] (data, response, error) in
            if let error = error {
                self?.finishSearching(_queryString, [], error)
                return
            }
            if let products = try? JSONDecoder().decode([ProductPreview].self, from: data!) {
                self?.finishSearching(_queryString, products, nil)
            }
        }
    }
    
    private func finishSearching(_ queryString: String, _ products: [ProductPreview], _ error: Error?) {
        self.callback?(queryString, products, error)
        self.callback = nil
    }
    
    private func startCountdown() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) {[weak self] (timer) in
            self?.performSearching()
        }
    }
}
