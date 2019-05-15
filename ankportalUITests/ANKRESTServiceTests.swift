//
//  ANKRESTServiceTests.swift
//  ankportalUITests
//
//  Created by Admin on 26/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import XCTest
@testable import ankportal

class ANKRESTServiceProductListTests: XCTestCase {

    private var restService: ANKRESTService?
    
    override func setUp() {
        restService = ANKRESTService(type: .productList)
        given(parameter: RESTParameter(name: "f_PROPERTY_BRAND_ID", value: "558"))
    }
    
    func given(parameter: RESTParameter) {
        restService?.add(parameter: parameter)
    }

    func testSerialize() {
        let serialized = restService?.serialize()
        
        XCTAssertEqual(serialized, "https://ankportal.ru/rest/index.php?get=productlist&f_PROPERTY_BRAND_ID=558")
    }
    
    func testPrepareTask() {
        let dataTask = restService?.prepareTask()
    
        XCTAssertTrue(dataTask != nil)
    }
    
    func testExecute() {
        let expectation = XCTestExpectation(description: "Download json from ankportal REST")
        
        restService?.execute(callback: { (d, u, e) in
            XCTAssertNotNil(d)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testCyrillicURL() {
        restService?.add(parameter: RESTParameter(name: "f_PROPERTY_IS_NEW.VALUE", value: "Да"))
        XCTAssertNotNil(URL(string: restService!.serialize()))
    }
}
