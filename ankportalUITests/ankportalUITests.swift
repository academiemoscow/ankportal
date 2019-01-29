//
//  ankportalUITests.swift
//  ankportalUITests
//
//  Created by Admin on 24/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import XCTest

class ankportalUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTypingAndSendingText() {
        
        let collectionView = app.collectionViews.element(boundBy: 0)
        let cellsCount = collectionView.cells.count
        
        
        let word = ["Hello"]
        for w in word {
            let textField = app.textFields["Текст сообщения..."]
            textField.tap()
        
            for c in w {
                let key = app.keys[String(c)]
                key.tap()
            }
            
            let button = app.buttons["Отпр"]
            button.tap()
        }
        XCTAssert(collectionView.cells.count - cellsCount <= 1)
        
    }

}
