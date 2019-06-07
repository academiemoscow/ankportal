//
//  ExtensionsTests.swift
//  ankportal
//
//  Created by Admin on 17/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import XCTest
@testable import ankportal

class ExtensionsTests: XCTestCase {

    func testMapToRESTParameterArray() {
        let testArray = [1, 2, 3, 5]
        let mappedArray = testArray.mapToRESTParameterArray(forRESTFilter: .id)
        XCTAssert(
            type(of: mappedArray) == [RESTParameter].self &&
            mappedArray.count == testArray.count
        )
    }
    
    func testCompareRESTParameterArrays() {
        let array11: [RESTParameter] = [
            RESTParameter(filter: .brandId, value: "1"),
            RESTParameter(filter: .brandId, value: "2")
        ]
        
        let array12: [RESTParameter] = [
            RESTParameter(filter: .brandId, value: "1"),
            RESTParameter(filter: .brandId, value: "2")
        ]
        
        let array21: [RESTParameter] = [
            RESTParameter(filter: .brandId, value: "1"),
            RESTParameter(filter: .brandId, value: "2")
        ]
        
        let array22: [RESTParameter] = [
            RESTParameter(filter: .brandId, value: "1"),
            RESTParameter(filter: .brandId, value: "3")
        ]
        
        XCTAssert(array11 == array12 && !(array21 == array22))
    }

}
