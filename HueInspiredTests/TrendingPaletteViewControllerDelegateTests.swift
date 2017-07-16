//
//  TrendingPaletteViewControllerDelegateTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import CoreData
import PromiseKit
@testable import HueInspired

class TrendingPaletteViewControllerDelegateTests: XCTestCase {
    
    class MockRemotePaletteService:TrendingPaletteService {
        
        enum MockPaletteError: Error {
            case noTestData
        }
        
        private var testData: UserOwnedPalette?

        init(testData:UserOwnedPalette?=nil){
            self.testData = testData
        }
        
        func nextPalette() -> Promise<ColorPalette> {
            //let p = ImmutablePalette.init(name: "foo", colorData: [], image: nil, guid: nil)
            if let testData = testData{
                return Promise(value: testData)
            }
            else{
                return Promise.init(error: MockPaletteError.noTestData)
            }
            
        }
    }
    
    private var testDataStack: NSPersistentContainer!
    
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

    func test_didPullRefresh_resetDisplayState_onFulfil (){
        // Trending Delegate will reset display state once palette fulfils
        
        // SETUP
        let vc = MockPaletteViewController.init()
        let service = MockRemotePaletteService(testData: ImmutablePalette(name: "foo", colorData: [], image: nil, guid: nil))
        let delegate = TrendingPaletteDelegate.init(factory: { _ -> UserPaletteDataSource? in
            return nil // won't be used in tests
        }, ctx: testDataStack.viewContext, remotePalettes:service)
        vc.currentDisplayState = .pending
        
        // TEST
        let expect = expectation(description: "Promised Palette should fulfil")
        delegate.didPullRefresh(viewController: vc)
        
        service.nextPalette().always {
            expect.fulfill()
        }
        
        // POSTCONDITION
        waitForExpectations(timeout: 0.1) { (_) in
            XCTAssertEqual(vc.currentDisplayState, .final)
        }
    }
    
    func test_didPullRefresh_resetDisplayState_onReject (){
        // Trending Delegate will reset display state once palette rejects
        
        // SETUP
        let vc = MockPaletteViewController.init()
        let service = MockRemotePaletteService()
        let delegate = TrendingPaletteDelegate.init(factory: { _ -> UserPaletteDataSource? in
            return nil // won't be used in tests
        }, ctx: testDataStack.viewContext, remotePalettes: service)
        vc.currentDisplayState = .pending
        
        // TEST
        let expect = expectation(description: "Promised Palette should reject")
        delegate.didPullRefresh(viewController: vc)
        
        service.nextPalette().always {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.1) { (_) in
            // POSTCONDITION
            XCTAssertEqual(vc.currentDisplayState, .final)
        }
    }
    
    func test_didPullRefresh_createsNewPalette (){
        // Trending Delegate will use promised palettes from service dependency
        // and create a new palette in core data context.
        
        // SETUP
        let vc = MockPaletteViewController.init()
        let service = MockRemotePaletteService(testData: ImmutablePalette(name: "foo", colorData: [], image: nil, guid: nil))
        let delegate = TrendingPaletteDelegate.init(factory: { _ -> UserPaletteDataSource? in
            return nil // won't be used in tests
        }, ctx: testDataStack.viewContext, remotePalettes: service)
        let fetchRequest: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()

        // PRE CONDITION
        XCTAssertEqual(try? self.testDataStack.viewContext.fetch(fetchRequest).count, 0)

        // TEST
        let expect = expectation(description: "Promised Palette should fulfil")
        delegate.didPullRefresh(viewController: vc)
        
        // mock service returns same promise! can just recall to schedule expectation fulfilment
        service.nextPalette().always {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.1) { (_) in
            // POSTCONDITION
            XCTAssertEqual(vc.currentDisplayState, .final)
            
            XCTAssertEqual(try? self.testDataStack.viewContext.fetch(fetchRequest).count, 1)
        }
    }

    
}
