//
//  DataSourceTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import CoreData
import PromiseKit
@testable import HueInspired

// MARK: HELPERS

class MockDataSourceObserver: DataSourceObserver {
    
    var fired: Promise<Bool>
    var doFire: (Bool) -> ()
    
    init(){
        let (promise, fulfill, _) = Promise<Bool>.pending()
        fired = promise
        doFire = fulfill
    }
    
    func dataDidChange(currentState:DataSourceState) {
        doFire(true)
    }
}

// MARK: TESTS

class View_DataSourceTests: XCTestCase {
    
    /*
        The DataSource object is interface between the View Controller
        and the data.
     
        Our implementation is mostly a wrapper around the FetchedResultsController
        so tests verify given a context with known state, the data source
        should present correct data.
     
    */
    
    
    var testDataStack: NSPersistentContainer?
    var defaultFetchRequest: NSFetchRequest<CDSColorPalette>?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
        
        let request: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        defaultFetchRequest = request 
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }
    
    // HELPER
    
    func setupDataSource() -> CoreDataPaletteDataSource {
        let context = testDataStack!.viewContext
        let fetchController = NSFetchedResultsController(fetchRequest: defaultFetchRequest!, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return CoreDataPaletteDataSource(data: fetchController)
    }
    
    
    // TESTS
    
    func test_startsEmpty(){
        // Until we call sync the dataSource should be in an empty state
        
        let data = setupDataSource()
        XCTAssertTrue(data.count == 0)
    }
    
    
    func test_countReturnsNumberOfObjectsinFetchController(){
        // the dataSource should return the number of objects in the 
        // fetch controller which itself should return any palette instance
        // in the context.
        // This number should update as context changes
        
        // Setup
        let context = testDataStack!.viewContext
        context.performAndWait{
            let _ = CDSColorPalette(
                context: context,
                palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil)
            )
            try! context.save()
        }
        
        let e = expectation(description: "DataSource should Increment by 1")
        let dataSource = setupDataSource()
        try? dataSource.syncData()
        dataSource.workQueue.async {
            e.fulfill() // Bit of a cheat ...
        }
        // TEST
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(dataSource.count, 1)
        
        // Now Add another Palette
        context.performAndWait{
            let _ = CDSColorPalette(
                context: context,
                palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil)
            )
            try! context.save()
        }
        
        // TEST
        // datasource should show up to date count number
        
        XCTAssertEqual(dataSource.count, 2)
        
    }
    
    func test_dataSourceNotifiesObserverOnChange(){
        // As part of the datasource interface, an object can subscribe 
        // to changes as long as they implement observer protocol
        // The observer should be notified on all changes
        
        // WE need test it fires on 
        // updates
        // initial sync
        // on first subscription? maybe
        
        
        // Setup
        let context = testDataStack!.viewContext
        let dataSource = setupDataSource()
        try? dataSource.syncData()
        let mock = MockDataSourceObserver()
        dataSource.observer = mock
        
        // update content
        context.performAndWait{
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        
        // TEST
        let e = expectation(description: "Observer should fire eventually ")
        dataSource.workQueue.async {
            e.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(mock.fired.value, true)
        
    }
}
