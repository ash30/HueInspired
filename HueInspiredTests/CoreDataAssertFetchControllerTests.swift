//
//  CoreDataAssertFetchControllerTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 05/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

import XCTest
import CoreData
@testable import HueInspired

class CoreDataAssertFetchControllerTest: XCTestCase {
    
    /*
        Simple Tests to prove NSFetchRequest can respond to changes made main and background contexts
    */
    
    
    // MARK: HELPERS 
    
    private class MockFetchControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        
        typealias notificationCallback = () -> ()
        
        var didCall: notificationCallback?
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
            didCall?()
        }

    }
    
    private var testDataStack: NSPersistentContainer!
    
    private var defaultFetchRequest: NSFetchRequest<CDSColorPalette> {
        let f: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        f.sortDescriptors = [NSSortDescriptor.init(key: #keyPath(CDSColorPalette.creationDate), ascending: true)]
        return f
    }
    
    // MARK: LIFE CYCLE
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }
    
    // MARK: TESTS
    
    func test_fetchControllerNotifiesDelegateOnContextChange() {
        // Changes on view context causes fetch controller to be notified
        
        // SETUP
        let controller = NSFetchedResultsController<CDSColorPalette>(
            fetchRequest: defaultFetchRequest,
            managedObjectContext: testDataStack.viewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        let mockDelegate = MockFetchControllerDelegate()
        controller.delegate = mockDelegate
        let e = expectation(description: "Observer should fire after changes are merged ")

        mockDelegate.didCall = {
            e.fulfill()
        }
        
        try? controller.performFetch()
        
        // TEST
        testDataStack.viewContext.performAndWait{
            
            _ = CDSColorPalette(context: self.testDataStack.viewContext, palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            do{
                try self.testDataStack.viewContext.save()
            }
            catch {
                fatalError()
            }
        }
        
        // POST CONDITION
        waitForExpectations(timeout: 1.0, handler: { (error:Error?) in
            // Delegate was called due to changes being merged into the context
            XCTAssertEqual(controller.fetchedObjects!.count, 1)
        })
    }
    
    func test_fetchControllerNotifiesDelegateOnBackgroundContextMerge() {
        // Background saves should merge with view context hence notify controller
        // This should be the same as before, except switch the context
        
        // SETUP
    
        // This is super important! Must set if you want saved notifications to be merged
        testDataStack.viewContext.automaticallyMergesChangesFromParent = true
        
        let controller = NSFetchedResultsController<CDSColorPalette>(
            fetchRequest: defaultFetchRequest,
            managedObjectContext: testDataStack.viewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        let mockDelegate = MockFetchControllerDelegate()
        controller.delegate = mockDelegate
        try! controller.performFetch()
        
        let e = expectation(description: "Observer should fire after changes are merged ")
        mockDelegate.didCall = {
            e.fulfill()
        }
        
        // PRECONDITION
        XCTAssertEqual(controller.fetchedObjects?.count, 0)
        
        // TEST
        testDataStack.performBackgroundTask { (ctx:NSManagedObjectContext) in
            _ = CDSColorPalette(context: ctx, palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            try! ctx.save()

        }
        
        // POST CONDITION
        waitForExpectations(timeout: 1.0, handler: { (error:Error?) in
            // Delegate was called due to changes being merged into the context
            XCTAssertEqual(controller.fetchedObjects!.count, 1)
        })
    }
}
