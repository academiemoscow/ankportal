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
        return "https://ankportal.ru/rest/index2.php?"
    }
}

protocol ProductFinderDelegate {
    func willSearch(_ finder: ProductFinder)
    func didSearch(_ finder: ProductFinder, withProducts products: [ProductPreview], _ queryString: String, _ error: Error?)
}

class ProductFinder {
    
    /** Delay before request in seconds */
    private let delay: TimeInterval = 0.5
    
    private var queryString: String = ""
    
    private var restService: ANKRESTService?
    
    private var timer: Timer?
    
    public var delegate: ProductFinderDelegate?
    
    func find(byString query: String) {
        if (query == queryString || query == "") {
            return
        }
        queryString = query
        startCountdown()
    }
    
    private func performSearching() {
        delegate?.willSearch(self)
        let _queryString = queryString
        restService = ANKRESTService(type: .productList)
        restService?.add(parameter: RESTParameter(filter: .searchString, value: _queryString))
        restService?.execute {[weak self] (data, response, error) in
            if let error = error {
                self?.finishSearching(_queryString, [], error)
                return
            }
            do {
                let products = try JSONDecoder().decode([ProductPreview].self, from: data!)
                self?.finishSearching(_queryString, products, nil)
            } catch {
                self?.finishSearching(_queryString, [], error)
            }
        }
    }
    
    private func finishSearching(_ queryString: String, _ products: [ProductPreview], _ error: Error?) {
        delegate?.didSearch(self, withProducts: products, queryString, error)
    }
    
    private func startCountdown() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) {[weak self] (timer) in
            self?.performSearching()
        }
    }
}
