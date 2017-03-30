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
    
    var testDataStack: NSPersistentContainer?
    
    override func setUp() {
        super.setUp()
        testDataStack = setupDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        testDataStack = nil
    }
    
    func test_getFavs_noPrexist_mainContext(){
        // First time you run the app and get favourites, you should create a selection set
        
        let viewCtx = testDataStack!.viewContext
        viewCtx.performAndWait {
            XCTAssertNotNil(try? PaletteFavourites.getSelectionSet(for:viewCtx))
        }
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
    
    func test_newFavouriteNotifiesFavouriteView(){
        // when we create a new favorite via detail view, we should update favourites view
        
        let backgoundCtx = testDataStack!.newBackgroundContext()
        let viewCtx = testDataStack!.viewContext
        backgoundCtx.performAndWait {
            CDSColorPalette(context: viewCtx, name: "test1", colors: [])
        }
        try! backgoundCtx.save()
        let favourites = AppDelegate.container.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Favs", argument:viewCtx)!
        let detailController = AppDelegate.container.resolve(PaletteDetailController.self, argument:backgoundCtx)!
        try! favourites.performFetch()
        detailController.dataSource?.syncData()
        
        // PRECONDITION
        XCTAssertEqual(favourites.fetchedObjects?.count ?? -1, 0)
        XCTAssertEqual(detailController.dataSource?.count ?? -1, 1)
        
        // TEST
        try! detailController.didToggleFavourite(index: 0)
        
        // POST CONDITION
        XCTAssertEqual(favourites.fetchedObjects?.count ?? -1, 1)

        
    }
    
}
