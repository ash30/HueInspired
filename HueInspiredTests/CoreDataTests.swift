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

/*
 
 Just couldn't get this to work with dual attributes
 Having two attribute unique constraint just wasn't erroring

 For now I'm just going to forgo image origin and just unique
 on a single attribute 'id'
 
class CoreDataUniquenessAssertions: XCTestCase {
    
    var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }
    
    func test_twoAttributeConstraint_SingleMatch(){
        // The save should be fine? as only a single constrained attribute matches 
        
        let context = testDataStack!.viewContext
        context.mergePolicy = NSMergePolicy.error

        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()
        //fetch.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: true)]
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0)

        context.performAndWait {
            _ = CDSImageSource(context: context, id: "Foo", origin: "a", palette: nil, imageData: nil)
            _ = CDSImageSource(context: context, id: "Foo", origin: "b", palette: nil, imageData: nil)
        }
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 2)
        XCTAssertNotNil(try? context.save())
    }
    
    func test_twoAttributeConstraint_OtherSingleMatch(){
        // The save should fail as both constrained attributes match
        
        let context = testDataStack!.viewContext
        context.mergePolicy = NSMergePolicy.error
        
        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()
        //fetch.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: true)]
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0)
        
        context.performAndWait {
            _ = CDSImageSource(context: context, id: "Foo2", origin: "a", palette: nil, imageData: nil)
            _ = CDSImageSource(context: context, id: "Foo1", origin: "a", palette: nil, imageData: nil)
        }
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 2)
        XCTAssertNotNil(try? context.save())
    }
    
    func test_twoAttributeConstraint_DoubleMatch(){
        // The save should fail as both constrained attributes match
        
        let context = testDataStack!.viewContext
        context.mergePolicy = NSMergePolicy.error
        
        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()

        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0)
        
        context.performAndWait {
            let b = CDSImageSource(context: context, id: "Foo", origin: "a", palette: nil, imageData: nil)
            let a = CDSImageSource(context: context, id: "Foo", origin: "a", palette: nil, imageData: nil)
            
            XCTAssertEqual(a.externalID, "Foo")
            XCTAssertEqual(a.origin, "a")
            XCTAssertEqual(b.externalID, "Foo")
            XCTAssertEqual(b.origin, "a")
        }
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 2)

        XCTAssertNil(try? context.save())
    }
 
    // TEST ENT VERSION
    
    func test_twoAttributeConstraint_DoubleMatch_TestEnt(){
        // The save should fail as both constrained attributes match
        
        let context = testDataStack!.viewContext
        context.mergePolicy = NSMergePolicy.error
        
        let fetch: NSFetchRequest<TestEnt> = TestEnt.fetchRequest()
        
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0)
        
        context.performAndWait {
            let a = TestEnt(context: context)
            a.externalID = "foo"
            a.origin = "spam"
            let b = TestEnt(context: context)
            b.externalID = "foo"
            b.origin = "spam"
        }
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 2)
        
        XCTAssertNil(try? context.save())
    }
    
}
*/

class ImageSourceTests: XCTestCase {
    
    var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }
    

    
}


class CoreDataDeleteAssertions: XCTestCase {
    
    var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }
    
    func test_deletedItemsNotInCount() {
        
        let context = testDataStack!.viewContext
        
        let fetch: NSFetchRequest<CDSSelectionSet> = CDSSelectionSet.fetchRequest()
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        let palette = CDSSelectionSet(context: context, name: "foo")
        
        // PRECONDITION
        // We should start off with 0 objects
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1 )
        
        // TEST
        context.delete(palette)
        
        // POST CONDITION 
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0 )
    }
    
    func test_deletedSavedItemsNotInCount() {
        
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

class CoreDataMergeAssertions: XCTestCase {

    var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }

    
    func test_merge_saveBackgrounContexts_updatesMain(){
        // Saving a bckground context auto syncs the new items to view context
        
        // SETUP
        let context = testDataStack!.viewContext
        let backgroundContext = testDataStack!.newBackgroundContext()
        
        let fetch: NSFetchRequest<CDSSelectionSet> = CDSSelectionSet.fetchRequest()
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        // PRECONDITION
        // We should start off with 0 objects
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0 )
        
        // TEST
        _ = CDSSelectionSet(context: backgroundContext, name: "foo")
        XCTAssertNotNil(try? backgroundContext.save())
        
        // POST CONDITION
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1 )
        
    }
    
    func test_merge_saveMainContext_updatesBackground() {
        // Saving the view context syncs with new items to background context
        
        // SETUP
        let context = testDataStack!.viewContext
        let backgroundContext = testDataStack!.newBackgroundContext()
        
        let fetch: NSFetchRequest<CDSSelectionSet> = CDSSelectionSet.fetchRequest()
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        // PRECONDITION
        // We should start off with 0 objects
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0 )
        XCTAssertEqual( (try? backgroundContext.fetch(fetch).count) ?? -1, 0 )
        
        // TEST
        _ = CDSSelectionSet(context: context, name: "foo")
        XCTAssertNotNil(try? context.save())
        
        // POST CONDITION
        XCTAssertEqual( (try? backgroundContext.fetch(fetch).count) ?? -1, 1 )
        
    }
    
    
    func test_mergeFail_conflictingConstraints(){
        // Merge should fail if set already exists in main context
        
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
        
        
        // TEST
        _ = CDSSelectionSet(context: backgroundContext, name: "foo")
        
        // POST CONDITION
        // This should fail, one copy already exists in main
        XCTAssertNil(try? backgroundContext.save())
        // And as it failed, only 1 item in main context
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1 )
        
    }
    
    // MARK: Testing out the default merge policy in relation to unique constraints
    
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
        // If Part of the object graph fails validation, the whole graph of
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
        XCTAssertNil((try! context.fetch(fetch)).first?.palette)
    }
    
    func test_mergeUniqueConflicts_rollback_relationsOpposite(){
        // If Part of the object graph fails validation, the whole graph of
        // objects are rejected
        
        // SETUP
        let context = testDataStack!.viewContext
        context.mergePolicy = NSMergePolicy.rollback
        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()
        
        // TEST
        _ = CDSImageSource(
            context: context, id: "Foo",
            palette: CDSColorPalette.init(
                context: context, name: "Palette1", colors: []
            ),
            imageData: nil)
        
        XCTAssertNotNil(try? context.save())

        _ = CDSImageSource(context: context, id: "Foo", palette: nil, imageData: nil)
        
        XCTAssertNotNil(try? context.save())
        
        // POST CONDITION
        // One Item should have been discarded from memory automatically
        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 1)
        
        // we should keep first image source which DOES have a palette
        XCTAssertNotNil((try! context.fetch(fetch)).first?.palette)
    }
    
}
