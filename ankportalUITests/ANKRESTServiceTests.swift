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
    }

    func testSerialize() {
        given(parameter: RESTParameter(name: "f_PROPERTY_BRAND_ID", value: "558"))
        
        let serialized = restService?.serialize()
        
        XCTAssertEqual(serialized, "https://ankportal.ru/rest/index.php?get=productlist&f_PROPERTY_BRAND_ID=558")
    }
    
    func testGetDataTask() {
        given(parameter: RESTParameter(name: "f_PROPERTY_BRAND_ID", value: "558"))
    
        let dataTask = restService?.prepareTask()
    
        XCTAssertTrue(dataTask != nil)
    }
    
    func given(parameter: RESTParameter) {
        restService?.add(parameter: parameter)
    }
}
