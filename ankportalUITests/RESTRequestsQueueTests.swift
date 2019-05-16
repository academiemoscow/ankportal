//
//  RESTRequestsQueueTests.swift
//  ankportalTests
//
//  Created by Admin on 15/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import XCTest
@testable import ankportal

class RESTRequestsQueueTests: XCTestCase {

    private var restQueue: RESTRequestsQueue?
    
    override func setUp() {
        restQueue = RESTRequestsQueue()
    }

    func testExecute() {
        let expectation = XCTestExpectation(description: "Download json from ankportal REST")
        let expectation1 = XCTestExpectation(description: "Download json from ankportal REST1")
        let restService = ANKRESTService(type: .productList)
        restService.add(parameter: RESTParameter(name: "f_PROPERTY_BRAND_ID", value: "559"))
        let restService1 = ANKRESTService(type: .productList)
        restService1.add(parameter: RESTParameter(name: "f_PROPERTY_BRAND_ID", value: "558"))
        
        var rest = false
        var rest1 = false
        restQueue?.add(request: restService, completion: { (d, u, e) in
            print(u!)
            rest = d != nil
            expectation.fulfill()
        })
        restQueue?.add(request: restService1, completion: { (d, u, e) in
            print(u!)
            rest1 = d != nil
            expectation1.fulfill()
        })
    
        wait(for: [expectation, expectation1], timeout: 10.0)
        XCTAssert(rest && rest1)
    }

}
