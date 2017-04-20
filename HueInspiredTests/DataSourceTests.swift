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
    
    func dataDidChange() {
        doFire(true)
    }
}

// MARK: TESTS

class View_DataSourceTests: XCTestCase {
    
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
        let data = setupDataSource()
        XCTAssertTrue(data.count == 0)
    }
    
    func test_countReturnsNumberOfObjectsinFetchController(){
        
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
        dataSource.syncData()
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
        // Setup
        let context = testDataStack!.viewContext
        let dataSource = setupDataSource()
        dataSource.syncData()
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
