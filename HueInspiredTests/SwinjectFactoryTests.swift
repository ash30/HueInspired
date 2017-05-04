//
//  SwinjectFactoryTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import CoreData
import Swinject

@testable import HueInspired

class SwinjectFactoryTests: XCTestCase {
    
    var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }
    
    func test_resolveFavouritesData_mainContext(){
        
        let ctx = testDataStack!.viewContext
        _ = AppDelegate.container.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Favs", argument:ctx)!
    }
    
    func test_resolveFavouritesData_backgroundContext(){
        
        let ctx = testDataStack!.newBackgroundContext()
        _ = AppDelegate.container.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Favs", argument:ctx)!
    }
    
    
}
