//
//  SOAPProductRecieverTests.swift
//  ankportal
//
//  Created by Admin on 04/07/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import XCTest
@testable import ankportal

class SOAPProductRecieverTests: XCTestCase {

    func testFetchData() {
        let expectation = XCTestExpectation(description: "Fetch data")
        let soapReciever = SOAPProductReciever()
        soapReciever.fetchProduct(by: "test") { (product) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

}
