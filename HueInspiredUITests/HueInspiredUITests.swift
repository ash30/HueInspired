//
//  HueInspiredUITests.swift
//  HueInspiredUITests
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import XCTest





class HueInspiredUITests: XCTestCase {
    
    var app:XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        app = XCUIApplication()
        
        // Having problems with in memory persistence store, for now we just cleanup the disk explictly
        app.launchArguments = ["DATA_CLEAN", "DISABLE_ONBOARD"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_createFromUserImage() {
        // User should be able to create palette from image in picker
        
        app.tabBars.buttons["+"].tap()
        app.tables.buttons["Camera Roll"].tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, March 13, 2011, 12:17 AM"].tap()
        app.buttons["Save"].tap()
        
        XCTAssertEqual(
            XCUIApplication().tables.children(matching: .cell).matching(identifier: "PaletteItem").count,
            1
        )
    }
    
    func test_cannotCreateDuplicatePalette() {
        // You can't resave a palette that already exists
        
        app.tabBars.buttons["+"].tap()
        app.tables.buttons["Camera Roll"].tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, March 13, 2011, 12:17 AM"].tap()
        app.buttons["Save"].tap()
        
        XCTAssertEqual(
            XCUIApplication().tables.children(matching: .cell).matching(identifier: "PaletteItem").count,
            1
        )
        
        // Repeat action
        app.tabBars.buttons["+"].tap()
        app.tables.buttons["Camera Roll"].tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, March 13, 2011, 12:17 AM"].tap()
        app.buttons["Save"].tap()
        
        XCTAssertEqual(app.alerts.count, 1)
    }
    
    func test_dragToRefreshTrendingTable() {
        let header = app.tables.staticTexts["HueInspired"]
        let start = header.coordinate(withNormalizedOffset: CGVector.init(dx: 0, dy: 0))
        let finish = header.coordinate(withNormalizedOffset: CGVector.init(dx: 0, dy: 10))
        start.press(forDuration: 0, thenDragTo: finish)

        
    }
    
}
