//
//  CoreDataAssertDeletionTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 05/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import HueInspired

class CoreDataAssert_Deletion: XCTestCase {
    
    // Simple tests to verify deletion of managed entities 
    
    // MARK: HELPERS
    
    private var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }
    
    // MARK: TESTS
    
    func test_deletedItemsNotInCount() {
        // Items not saved yet are successfully deleted and not reported in fetch count
        
        let context = testDataStack!.viewContext
        
        let fetch: NSFetchRequest<CDSSelectionSet> = CDSSelectionSet.fetchRequest()
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        let palette = CDSSelectionSet(context: context, name: "foo")
        
        // PRECONDITION
        // We should start off with 1 objects
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1 )
        
        // TEST
        context.delete(palette)
        
        // POST CONDITION
        // After deletion, 0 objects
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0 )
    }
    
    func test_deletedSavedItemsNotInCount() {
        // Previously saved items are delete and not reported in fetch count
        
        let context = testDataStack!.viewContext
        
        let fetch: NSFetchRequest<CDSSelectionSet> = CDSSelectionSet.fetchRequest()
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        let palette = CDSSelectionSet(context: context, name: "foo")
        XCTAssertNotNil(try? context.save())
        
        // PRECONDITION
        // We should start off with 0 objects
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1 )
        
        // TEST
        context.delete(palette)
        
        // POST CONDITION
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0 )
    }
    
}
