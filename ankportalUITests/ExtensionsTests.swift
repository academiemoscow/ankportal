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

}
