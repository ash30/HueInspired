//
//  CoreDataAssertUniquenessTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 05/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import HueInspired

//Just couldn't get this to work with dual attributes
//Having two attribute unique constraint just wasn't erroring
//
//For now I'm just going to forgo image origin and just unique
//on a single attribute 'id'
//
//class CoreDataUniquenessAssertions: XCTestCase {
//    
//    var testDataStack: NSPersistentContainer?
//    
//    override func setUp() {
//        super.setUp()
//        testDataStack = setupDataStack()
//    }
//    
//    override func tearDown() {
//        super.tearDown()
//        testDataStack = nil
//    }
//    
//    func test_twoAttributeConstraint_SingleMatch(){
//        // The save should be fine? as only a single constrained attribute matches
//        
//        let context = testDataStack!.viewContext
//        context.mergePolicy = NSMergePolicy.error
//        
//        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()
//        //fetch.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: true)]
//        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0)
//        
//        context.performAndWait {
//            _ = CDSImageSource(context: context, id: "Foo", origin: "a", palette: nil, imageData: nil)
//            _ = CDSImageSource(context: context, id: "Foo", origin: "b", palette: nil, imageData: nil)
//        }
//        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 2)
//        XCTAssertNotNil(try? context.save())
//    }
//    
//    func test_twoAttributeConstraint_OtherSingleMatch(){
//        // The save should fail as both constrained attributes match
//        
//        let context = testDataStack!.viewContext
//        context.mergePolicy = NSMergePolicy.error
//        
//        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()
//        //fetch.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: true)]
//        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0)
//        
//        context.performAndWait {
//            _ = CDSImageSource(context: context, id: "Foo2", origin: "a", palette: nil, imageData: nil)
//            _ = CDSImageSource(context: context, id: "Foo1", origin: "a", palette: nil, imageData: nil)
//        }
//        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 2)
//        XCTAssertNotNil(try? context.save())
//    }
//    
//    func test_twoAttributeConstraint_DoubleMatch(){
//        // The save should fail as both constrained attributes match
//        
//        let context = testDataStack!.viewContext
//        context.mergePolicy = NSMergePolicy.error
//        
//        let fetch: NSFetchRequest<CDSImageSource> = CDSImageSource.fetchRequest()
//        
//        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0)
//        
//        context.performAndWait {
//            let b = CDSImageSource(context: context, id: "Foo", origin: "a", palette: nil, imageData: nil)
//            let a = CDSImageSource(context: context, id: "Foo", origin: "a", palette: nil, imageData: nil)
//            
//            XCTAssertEqual(a.externalID, "Foo")
//            XCTAssertEqual(a.origin, "a")
//            XCTAssertEqual(b.externalID, "Foo")
//            XCTAssertEqual(b.origin, "a")
//        }
//        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 2)
//        
//        XCTAssertNil(try? context.save())
//    }
//    
//    // TEST ENT VERSION
//    
//    func test_twoAttributeConstraint_DoubleMatch_TestEnt(){
//        // The save should fail as both constrained attributes match
//        
//        let context = testDataStack!.viewContext
//        context.mergePolicy = NSMergePolicy.error
//        
//        let fetch: NSFetchRequest<TestEnt> = TestEnt.fetchRequest()
//        
//        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 0)
//        
//        context.performAndWait {
//            let a = TestEnt(context: context)
//            a.externalID = "foo"
//            a.origin = "spam"
//            let b = TestEnt(context: context)
//            b.externalID = "foo"
//            b.origin = "spam"
//        }
//        XCTAssertEqual( (try? context.fetch(fetch).count) ?? -1, 2)
//        
//        XCTAssertNil(try? context.save())
//    }
//    
//}

