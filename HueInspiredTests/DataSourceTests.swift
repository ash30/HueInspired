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


class View_DataSourceTests: XCTestCase {
    
    /*
        The DataSource object is interface between the View Controller
        and the data.
     
        Our implementation is mostly a wrapper around the FetchedResultsController
        so tests verify given a context with known state, the data source
        should present correct data.
     
    */
    // MARK: MOCKS
    
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
    
    // MARK: HELPERS
    
    var testDataStack: NSPersistentContainer?
    
    var defaultFetchRequest: NSFetchRequest<CDSColorPalette> {
        let request: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        return request
    }
    
    func setupDataSource(predicate:NSPredicate? = nil) -> CoreDataPaletteDataSource {
        let context = testDataStack!.viewContext
        let fetchRequest = defaultFetchRequest
        fetchRequest.predicate = predicate
        let fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return CoreDataPaletteDataSource(data: fetchController)
    }
    
    // MARK: LIFECYCLE
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
        

    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }

    // MARK: TESTS
    
    // MARK: DATA SOURCE
    
    func test_startsEmpty(){
        // Until we call sync the dataSource should be in an empty state
        
        let data = setupDataSource()
        XCTAssertTrue(data.count == 0)
    }
    
    
    func test_countReturnsNumberOfObjectsinFetchController(){
        // the dataSource should return the number of objects in the 
        // fetch controller which itself should return any palette instance
        // in the context.
        
        // Setup
        let context = testDataStack!.viewContext
        context.performAndWait{
            let _ = CDSColorPalette(
                context: context,
                palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil)
            )
            try! context.save()
        }
        
        // TEST
        let dataSource = setupDataSource()
        try? dataSource.syncData()
        
        // POST CONDITIONS
        XCTAssertEqual(dataSource.count, 1)
    }
    
    func test_dataSourceNotifiesObserverOnChange(){
        // As part of the datasource interface, an object can subscribe 
        // to changes as long as they implement observer protocol
        // The observer should be notified on all changes
        
        // SETUP
        let context = testDataStack!.viewContext
        let dataSource = setupDataSource()
        try? dataSource.syncData()
        let mock = MockDataSourceObserver()
        dataSource.observer = mock
        
        // TEST
        context.performAndWait{
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        // POST CONDITION
        XCTAssertEqual(mock.fired.value, true)
        
    }
    
    // MARK: FILTERS
    
    func test_setfilter(){
        // You can filter a data source so that it only presents items matching predicate
        
        // SETUP
        let dataSource = setupDataSource()
        let context = testDataStack!.viewContext
        context.performAndWait{
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Test Palette", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        try? dataSource.syncData()
        
        // PRECONDITION
        XCTAssertEqual(dataSource.count, 1)
        
        // TEST
        dataSource.filterData(by: "NonPresent")
        
        // POST CONDITION
        XCTAssertEqual(dataSource.count, 0)
  
    }
    
    func test_clearFilter(){
        // when you clear filter, it reverts back to presenting all data
        // SETUP
        let dataSource = setupDataSource()
        let context = testDataStack!.viewContext
        context.performAndWait{
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Test Palette", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        try? dataSource.syncData()
        
        // PRECONDITION
        XCTAssertEqual(dataSource.count, 1)
        
        // TEST
        dataSource.filterData(by: "NonPresent")
        
        // POST CONDITION
        XCTAssertEqual(dataSource.count, 0)
        
        // TEST
        dataSource.clearFilter()
        
        // POST CONDITION
        XCTAssertEqual(dataSource.count, 1)
    }
    
    func test_clearFilter_noFilterPresent(){
        // clearing a fitler when none is present should be a noop
        
        // SETUP
        let dataSource = setupDataSource()
        let context = testDataStack!.viewContext
        context.performAndWait{
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Test Palette", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        try? dataSource.syncData()
        
        // PRECONDITION
        XCTAssertEqual(dataSource.count, 1)
        
        // TEST
        dataSource.clearFilter()
        
        // POST CONDITION
        XCTAssertEqual(dataSource.count, 1)
    }
    
    func test_setFilterWithExistingPredicate(){
        // If you created datasource with predicate already, then adding filter will be accumulative
        // aka: both will apply
        
        // SETUP
        let dataSource = setupDataSource(
            predicate: NSPredicate(format: "%K CONTAINS %@", argumentArray: [#keyPath(CDSColorPalette.name),"Test"])
        )
        let context = testDataStack!.viewContext
        context.performAndWait{
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Test Palette", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Test Palette 2", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Foo", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        try? dataSource.syncData()
        
        // PRECONDITION
        XCTAssertEqual(dataSource.count, 2)
        
        // TEST
        dataSource.filterData(by: "2")
        
        // POST CONDITION
        XCTAssertEqual(dataSource.count, 1)
        
    }
    
    func test_clearFilterWithExistingPredicate(){
        // Clearing filter will remove added filter BUT NOT original predicates
        
        // SETUP
        let dataSource = setupDataSource(
            predicate: NSPredicate(format: "%K CONTAINS %@", argumentArray: [#keyPath(CDSColorPalette.name),"Test"])
        )
        let context = testDataStack!.viewContext
        context.performAndWait{
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Test Palette", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Test Palette 2", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Foo", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        try? dataSource.syncData()
        
        // PRECONDITION
        XCTAssertEqual(dataSource.count, 2)
        
        // TEST
        dataSource.filterData(by: "2")
        
        // POST CONDITION
        XCTAssertEqual(dataSource.count, 1)
        
        // TEST
        dataSource.clearFilter()
        
        // POST CONDITION
        XCTAssertEqual(dataSource.count, 2)
        
    }
    
    func test_replaceInitialPredicate(){
        // You can replace original predicates so they become 'default' and unclearable
        
        // SETUP
        let dataSource = setupDataSource(
            predicate: NSPredicate(format: "%K CONTAINS %@", argumentArray: [#keyPath(CDSColorPalette.name),"Test"])
        )
        let context = testDataStack!.viewContext
        context.performAndWait{
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Test Palette", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Test Palette 2", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            _ = CDSColorPalette(context: context, palette: ImmutablePalette(name: "Foo", colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil, guid:nil))
            
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        try? dataSource.syncData()
        
        // PRECONDITION
        XCTAssertEqual(dataSource.count, 2)
        
        // TEST
        dataSource.replaceOriginalFilter(NSPredicate(format: "%K CONTAINS %@", argumentArray: [#keyPath(CDSColorPalette.name),"Foo"]))
        dataSource.clearFilter()

        // POST CONDITION
        XCTAssertEqual(dataSource.count, 1)
        
    }
    

}
