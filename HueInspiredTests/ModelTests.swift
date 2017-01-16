//
//  ModelTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 07/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import CoreData
import PromiseKit
@testable import HueInspired

class CDSPaletteTests: XCTestCase {

    var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testDataStack = nil
    }
    
    func test_attributes_name(){
        let context = testDataStack!.viewContext
        let result = CDSColorPalette(context: context, name: "test", colors: [])
        XCTAssertEqual(result.name, "test")
    }
    
    func test_attributes_name_nil(){
        let context = testDataStack!.viewContext
        let result = CDSColorPalette(context: context, name: nil, colors: [])
        XCTAssertNil(result.name)
    }
    
    func test_attributes_colors_empty(){
        let context = testDataStack!.viewContext
        let result = CDSColorPalette(context: context, name: nil, colors: [])
        XCTAssertEqual(result.colors.count, 0)
    }
    
    func test_attribute_colors_CDSCOlor(){
        let context = testDataStack!.viewContext
        let color = CDSColor(context: context, color: SimpleColor(r: 10, g: 11, b: 12))
        let result = CDSColorPalette(context: context, name: nil, colors: [color])
        
        XCTAssertEqual(result.colorData[0].r, 10)
        
    }
    
}



class CDSSelectionSetTests: XCTestCase {
    
    var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testDataStack = nil
    }

    func test_init(){
        let context = testDataStack!.viewContext
        
        context.perform {
            CDSSelectionSet(context: context, name: "Foo")
        }
    }
    
    func test_isMember_true_(){
        let context = testDataStack!.viewContext
        let palette =  CDSColorPalette(context: context, name:nil , colors: [])
        let selectionSet = CDSSelectionSet(context: context, name: "test")
        selectionSet.addPalette(palette)
        
        XCTAssertTrue(selectionSet.contains(palette))
    }
    
    func test_isMemeber_false(){
        let context = testDataStack!.viewContext
        let palette =  CDSColorPalette(context: context, name:nil , colors: [])
        let selectionSet = CDSSelectionSet(context: context, name: "test")
        
        XCTAssertFalse(selectionSet.contains(palette))
    }
}
