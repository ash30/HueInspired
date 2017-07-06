//
//  CoreDataTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import HueInspired

class CoreDataAssertMergeTests: XCTestCase {
    
    // A series of tests to verify behaviour when merging mutliple contexts
    
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

    func test_mergeFail_conflictingConstraints(){
        // Merge should fail if set with same name already exists in main context
        // Aka test uniquing constraints work correctly
        
        // SETUP
        let context = testDataStack!.viewContext
        let backgroundContext = testDataStack!.newBackgroundContext()
        
        context.mergePolicy = NSMergePolicy.error
        backgroundContext.mergePolicy = NSMergePolicy.error
        
        let fetch: NSFetchRequest<CDSSelectionSet> = CDSSelectionSet.fetchRequest()
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        // PRECONDITION
        // We should start off with 0 objects
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0 )
        // and a clean context
        XCTAssertFalse(context.hasChanges)
        
        // TEST
        _ = CDSSelectionSet(context: context, name: "foo")
        XCTAssertNotNil(try? context.save())
        
        // POSTCONDITION
        // We should now have 1 object in each context
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1 )
        XCTAssertEqual( (try? backgroundContext.fetch(fetch).count) ?? -1, 1 )
        
        
        // TEST PART2
        _ = CDSSelectionSet(context: backgroundContext, name: "foo")
        
        // POST CONDITION
        // This should fail, one copy already exists in persistence store
        XCTAssertNil(try? backgroundContext.save())
        // And as it failed, only 1 item in main context
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1 )
        
    }
    
    // MARK: verifying assumpitions for the different merge policies
    
    func test_mergeUniqueConflicts_error(){
        // Error does error on validation conflict  
        
        let context = testDataStack!.viewContext
        context.mergePolicy = NSMergePolicy.error
        
        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()
        
        context.performAndWait {
            _ = CDSImageSource(context: context, id: "Foo", palette: nil, imageData: nil)
            _ = CDSImageSource(context: context, id: "Foo", palette: nil, imageData: nil)
        }
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 2)
        XCTAssertNil(try? context.save())
    }
    
    func test_mergeUniqueConflicts_rollBack(){
        // Roll back removes item from context
        // As the validation only happens on save, you can temporarily break the unique constraints
        
        // SETUP
        let context = testDataStack!.viewContext
        context.mergePolicy = NSMergePolicy.rollback
        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()
        
        // TEST
        let a = CDSImageSource(context: context, id: "Foo", palette: nil, imageData: nil)
        let b = CDSImageSource(context: context, id: "Foo", palette: nil, imageData: nil)
        
        // Side note, these ids are just temps?
        let aID = a.objectID
        XCTAssertTrue(aID.isTemporaryID)
        XCTAssertNotNil(try? context.save())
        
        
        // POST CONDITION
        // One Item should have been discarded from memory automatically
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1)
        
    }
    
    func test_mergeUniqueConflicts_rollback_relations(){
        // If Part of the object graph fails validation and rolledback, the whole graph of
        // objects are rejected
        
        // SETUP
        let context = testDataStack!.viewContext
        context.mergePolicy = NSMergePolicy.rollback
        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()
        
        // PRECONDITION
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0)
        
        // TEST
        _ = CDSImageSource(context: context, id: "Foo", palette: nil, imageData: nil)
        XCTAssertNotNil(try? context.save())
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1)

        _ = CDSImageSource(
            context: context, id: "Foo",
            palette: CDSColorPalette.init(
                context: context, name: "Palette1", colors: []
            ),
            imageData: nil)
        
        XCTAssertNotNil(try? context.save())

        // POST CONDITION
        // One Item should have been discarded from memory automatically
        // context.refreshAllObjects()
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1)
        
        // we should keep first image source which doesn't have a palette
        // and not try and merge the two entities
        XCTAssertNil((try! context.fetch(fetch)).first?.palette)
    }
    
    func test_BackgroundContext_IdAfterSave(){
        // Ids don't appear to change after saving in bkground ctx 
        
        // SETUP
        let context = testDataStack!.newBackgroundContext()
        var id: NSManagedObjectID?
        var idValue: String?
        
        context.performAndWait {
            let a = CDSImageSource(context: context, id: "Foo", palette: nil, imageData: nil)
            id = a.objectID
            idValue = id?.uriRepresentation().debugDescription
        }
        
        // PRE CONDITION
        XCTAssertNotNil(id)
        
        // TEST
        XCTAssertNotNil(try? context.save())
        
        // POST CONDITION
        // After save, object should have same id 
        let a = context.object(with: id!)
        XCTAssertEqual(a.objectID.uriRepresentation().debugDescription, idValue!)
 
    }
}
