//
//  PaletteFavouriteTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import CoreData
import Swinject

@testable import HueInspired


class PaletteFavouriteTests: XCTestCase {
    
    /*
        Palette Favourites are really just instances of CDSSelectionSets
        We need to test that class level getter works. 
     
        More generally I wonder if it would be better to just inject it
        using swinject? That would mean you wouldn't need to test this at all....
 
    */
    
    
    var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }
    
    func test_getFavsChildPalettes_noPrexist_mainContext(){
        // First time you run the app and get favourites, you should create a selection set
        
        let viewCtx = testDataStack!.viewContext
        viewCtx.performAndWait {
            let selection = try? PaletteFavourites.getSelectionSet(for:viewCtx)
            XCTAssertNotNil(selection)
            XCTAssertNotNil(selection?.fetchMembers())
        }
    }
    
    func test_getFavsChildPalettes_PreExistingSet_mainContext() {
        
    }
    
    func test_PaletteFavourites(){
        
    }
    
    func test_blockNormalInit(){
        
    }
    
    
}
