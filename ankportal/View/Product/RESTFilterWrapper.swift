//
//  RESTFilterWrapper.swift
//  ankportal
//
//  Created by Admin on 22/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class RESTFilterWrapper {
    
    enum FilterValueType {
        case onOff
        case list
        case range
    }
    
    private var filter: RESTFilter
    private var type: FilterValueType
    private var value: [String] = []
    
    var name: String {
        get {
            return filter.description() ?? ""
        }
    }
    
    init(restFilter filter: RESTFilter, type: FilterValueType) {
        self.filter = filter
        self.type = type
    }
    
    public func setValue(_ value: [String]) {
        self.value = value
    }
    
    public func gerRESTParameters() -> [RESTParameter] {
        return value.mapToRESTParameterArray(forRESTFilter: filter)
    }
}
