//
//  ApplicationServiceTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 03/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//
import XCTest
import PromiseKit
import CoreData
@testable import HueInspired


class AppService_FavouritesManagerTests: XCTestCase {
    
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

class AppService_PaletteServiceTests: XCTestCase {

    class MockPhotoService: FlickrService {
        
        func getLatestInterests() -> Promise<[FlickrPhotoResource]> {
            let example = FlickrPhotoResource(id: "", owner: "", secret: "", server: "", farm: 0, title: "")
            return Promise.init(value: Array.init(repeating: example , count: 3))
        }
        func getPhoto(_ resource: FlickrPhotoResource) -> Promise<FlickrPhoto> {
            let image = UIImage(named: "testImage512")!
            return Promise(value: FlickrPhoto(description: resource, image: image))
        }
        
    }

    func test_mutipleImage() {
        // Make sure we return promise of array same length as photo service result
        
    }
    
}

class AppService_PaletteManagerTests: XCTestCase {

    var testDataStack: NSPersistentContainer?
    var defaultFetchRequest: NSFetchRequest<CDSColorPalette>?
    var paletteDataManager: LocalPaletteManager!
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
        
        let request: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        defaultFetchRequest = request
        
        paletteDataManager = LocalPaletteManager(dataLayer: testDataStack!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testDataStack = nil
    }
    
    
    func test_replaceAllPalettes_clearExisting() {
        // Replace should remove from context any palettes not assigned to a selection set
        
        // SETUP
        let e = expectation(description: "No Palettes in Context")
        let context = testDataStack!.viewContext
        
        context.performAndWait {
            let a = CDSColorPalette(context: context, name: nil, colors: [])
            let b = CDSColorPalette(context: context, name: nil, colors: [])
        }
        XCTAssertNotNil(try? context.save())
        
        // PRE CONDITION
        XCTAssertEqual(try? context.count(for: self.defaultFetchRequest!), 2 )
        
        // TEST
        _ = paletteDataManager.replace(with: []).then { (result:Bool) -> () in
            if try! context.count(for: self.defaultFetchRequest!) == 0 {
                e.fulfill()
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    
    func test_replaceAllPalettes_keepExistingFavourites() {
        // replace should keep any palette that is assigned a selection set
        
        // SETUP
        let e = expectation(description: "Keep all Palettes in Context")
        let context = testDataStack!.viewContext
        
        context.performAndWait {
            let a = CDSColorPalette(context: context, name: nil, colors: [])
            let c = CDSSelectionSet(context: context, name: "foo")
            c.addPalette(a)
        }
        XCTAssertNotNil(try? context.save())
        
        // PRE CONDITION
        XCTAssertEqual(try? context.count(for: self.defaultFetchRequest!), 1 )
        
        // TEST
        _ = paletteDataManager.replace(with: []).then { (result:Bool) -> () in
            if try! context.count(for: self.defaultFetchRequest!) == 1 {
                e.fulfill()
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
        
    }
    
    func test_replace_withNewPalettes() {
        // Old Palettes should be gone and new palette recreated into new core data item
        
        // SETUP
        let e = expectation(description: "One Palettes in Context")
        let context = testDataStack!.viewContext
        
        context.performAndWait {
            let a = CDSColorPalette(context: context, name: nil, colors: [])
            let b = CDSColorPalette(context: context, name: nil, colors: [])
        }
        XCTAssertNotNil(try? context.save())
        
        // PRE CONDITION
        XCTAssertEqual(try? context.count(for: self.defaultFetchRequest!), 2 )
        
        // TEST
        let newPalette = ImmutablePalette(name: "test", colorData: [], image: nil, guid:nil)
        
        _ = paletteDataManager.replace(with: [newPalette]).then { (result:Bool) -> () in
            if try! context.count(for: self.defaultFetchRequest!) == 1 {
                e.fulfill()
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_replace_updatesFetchResults(){
        
        // Old Palettes should be gone and new palette recreated into new core data item
        
        // SETUP
        let e = expectation(description: "One Palettes in Context")
        let context = testDataStack!.viewContext
        defaultFetchRequest?.shouldRefreshRefetchedObjects = true
        
        context.performAndWait {
            _ = CDSColorPalette(context: context, name: nil, colors: [])
            _ = CDSColorPalette(context: context, name: nil, colors: [])
        }
        XCTAssertNotNil(try? context.save())
        
        let palettes = defaultFetchRequest!
        let palettesController = NSFetchedResultsController(fetchRequest: palettes, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let dataSource = CoreDataPaletteDataSource(data: palettesController, favourites:nil)
        
        XCTAssertNotNil(try? palettesController.performFetch())
        XCTAssertEqual(dataSource.count,2)
        
        // PRE CONDITION
        XCTAssertEqual(try? context.count(for: self.defaultFetchRequest!), 2 )
        
        // TEST
        let newPalette = ImmutablePalette(name: "test", colorData: [], image: nil, guid:nil)
        
        _ = paletteDataManager.replace(with: [newPalette]).then { (result:Bool) -> () in
            
            XCTAssertEqual(try? context.count(for: self.defaultFetchRequest!), 1 )
            XCTAssertEqual(dataSource.count, 1)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        
    }
    
    
}
