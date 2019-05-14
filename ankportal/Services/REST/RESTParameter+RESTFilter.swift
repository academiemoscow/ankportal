//
//  RESTParameter.swift
//  ankportal
//
//  Created by Admin on 30/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

enum RESTFilter: String {
    case pageSize = "pagesize"
    case pageNumber = "PAGEN_1"
}

class RESTParameter {
    
    private var name: String
    private var value: String
    
    convenience init(filter: RESTFilter, value: String) {
        self.init(name: filter.rawValue, value: value)
    }
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    func serialize() -> String {
        return "&\(name)=\(value)"
    }
    
}
