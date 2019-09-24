//
//  ProductFinderTests.swift
//  ankportal
//
//  Created by Admin on 24/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import XCTest
@testable import ankportal

class ProductFinderTests: XCTestCase {
    
    private let finder = ProductFinder()
    
    private var callbacks: [((String, [ProductPreview], Error?) -> ())] = []
    
    private var expectations: [XCTestExpectation] = []
    
    private var result: [ProductPreview] = []
    
    private var queryString = ""
    
    override func setUp() {
        
        expectations = [
            XCTestExpectation(description: "Find products by string 08")
        ]
        
        callbacks = [
            
            { (queryString, products, error) in
                if let error = error {
                    XCTFail(error.localizedDescription)
                    return
                }
                self.result = products
                self.queryString = queryString
                self.expectations[0].fulfill()
            },
                     
            { (queryString, products, error) in
                if let error = error {
                    XCTFail(error.localizedDescription)
                    return
                }
                self.result = products
                self.queryString = queryString
                self.expectations[0].fulfill()
            },
            
            { (queryString, products, error) in
                if let error = error {
                    XCTFail(error.localizedDescription)
                    return
                }
                self.result = products
                self.queryString = queryString
                self.expectations[0].fulfill()
            }
        ]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFindDelay03() {
        finder.find(byString: "derm", callbacks[0])
        finder.find(byString: "3222", callbacks[1])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.finder.find(byString: "08", self.callbacks[2])
        }
        wait(for: expectations, timeout: 15.0)
        XCTAssert(queryString == "3222")
    }
    
    func testFindDelay02() {
        finder.find(byString: "derm", callbacks[0])
        finder.find(byString: "3222", callbacks[1])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.finder.find(byString: "08", self.callbacks[2])
        }
        wait(for: expectations, timeout: 15.0)
        XCTAssert(queryString == "08")
    }

}
