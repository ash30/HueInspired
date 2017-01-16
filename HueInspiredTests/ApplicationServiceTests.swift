//
//  ApplicationServiceTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 03/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import CoreData
import PromiseKit
@testable import HueInspired

// MARK: HELPERS

func setupDataStack() -> NSPersistentContainer {
    // Thanks: http://stackoverflow.com/questions/39004864/ios-10-core-data-in-memory-store-for-unit-tests#39005210
    
    let testDataStack = NSPersistentContainer(name: "HueInspired")
    
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    testDataStack.persistentStoreDescriptions = [description]

    testDataStack.loadPersistentStores{ (storeDescription, error) in
        if error != nil { fatalError() }
    }
    return testDataStack
}

struct MockDataSourceObserver: DataSourceObserver {
    
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

class PaletteDataSourceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func test_randomPaletteDataSource_defaultInit_Count(){
        // Count should return number of palettes
        
        let data = TestPaletteDataSource()
        XCTAssertEqual(data.count, data.testData.count)
    }
    
    func test_randomPaletteDataSource_defaultInit_GetPalette(){
        // get Palette should deterministically return first palette in data store
        
        let data = TestPaletteDataSource()
        //XCTAssertEqual(data.getPalette(at: 0)!, data.getPalette(at: 0)!)
        XCTAssertNotNil(data.getElement(at: 0), "Didn't return valid palette")
    }

}


class CoreDataPalatteDataSourceTests: XCTestCase {
    
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
    
    func test_alternative_init(){
        
        let context = testDataStack!.viewContext
        let data = CoreDataPaletteDataSource(context: context)
        
    }
    
    func test_startsEmpty(){
        let context = testDataStack!.viewContext
        let data = CoreDataPaletteDataSource(context: context)
        XCTAssertTrue(data.count == 0)
    }
    
    func test_countReturnsNumberOfObjectsinFetchController(){
        
        // Setup
        let context = testDataStack!.viewContext
        context.performAndWait{
            
            CDSColorPalette(context: context, palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil))
            
            do{
               try context.save()
            }
            catch {
                fatalError()
            }
        }
        
        // set up data source
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest() as! NSFetchRequest<CDSColorPalette>
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        let fetchController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let dataSource = CoreDataPaletteDataSource(data: fetchController)
        dataSource.syncData()
        
        XCTAssertEqual(dataSource.count, 1)
        
        // Now Add another Palette
        context.performAndWait{
            
            CDSColorPalette(context: context, palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil))
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        
        // datasource should show up to date count number
        XCTAssertEqual(dataSource.count, 2)

    }
    
    func test_dataSourceNotifiesObserverOnChange(){
        // Setup
        let context = testDataStack!.viewContext
        
        // set up data source
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        let fetchController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let dataSource = CoreDataPaletteDataSource(data: fetchController)
        dataSource.syncData()
        let mock = MockDataSourceObserver()
        dataSource.observer = mock
        
        // update content
        context.performAndWait{
            
            CDSColorPalette(context: context, palette: ImmutablePalette(name: nil, colorData: [SimpleColor.init(r: 9, g: 9, b: 9)], image: nil))
            
            do{
                try context.save()
            }
            catch {
                fatalError()
            }
        }
        
        XCTAssertEqual(mock.fired.value, true)
        
        
        
    }
}

class FavouritesManagerTests: XCTestCase {
    
    func test_init(){
        
    }
    
    func test_IsFavouriteTrue(){
        
    }
    
    func test_isFavouriteFalse(){
        
    }
    
    func test_addFavourite(){
        
    }
    
    func test_addFavouriteTwice(){
        
    }
    
    func test_removeFavourite(){
        
    }
    
    func test_removeFavourite_nonFavPalette(){
        
    }
    
    
    
}
