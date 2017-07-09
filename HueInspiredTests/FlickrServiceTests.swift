//
//  NetworkTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 19/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import Foundation
import PromiseKit
@testable import HueInspired

class MockNetworkManager: NetworkManager {
    var url: URL?
    
    func getData(_ request:URL, level: DispatchQoS.QoSClass) -> Promise<Data> {
        url = request
        return Promise<Data>.init(value: Data.init())
    }
}

class FlickrDataProviderTests: XCTestCase {
    
    var network: MockNetworkManager!
    var serviceProvider: FlickrServiceProvider!
    
    override func setUp() {
        super.setUp()
        network = MockNetworkManager()
        serviceProvider = FlickrServiceProvider.init(networkManager: network!, serviceConfig: FlickServiceConfig())
    }
    
    override func tearDown() {
        network = nil
        serviceProvider = nil
    }
    
    // MARK: TESTS
    
    func test_getInteresting_defaultRequest(){
    // ensure we're sending a sensible request to flickr api
        
        // TEST
        _ = serviceProvider.getLatestInterests(date:nil)
        
        // POST CONDITIONS
        XCTAssertNotNil(network.url)
        if let sent = network.url {
            XCTAssertTrue((sent.query ?? "").contains("format=json"))
            XCTAssertTrue((sent.query ?? "").contains("nojsoncallback=1"))
            XCTAssertTrue((sent.query ?? "").contains("flickr.interestingness.getList"))
            
        }
    }
    
    func test_getInteresting_specificPage(){
    // When user specifies a page number, we should send as a part of the request
        
        // TEST
        _ = serviceProvider.getLatestInterests(date:nil, page:2)
        
        // POST CONDITIONS
        XCTAssertNotNil(network.url)
        if let sent = network.url {
            XCTAssertTrue((sent.query ?? "").contains("page=2"))
        }
    }
    
    func test_getInteresting_specificDate(){
    // When user specifies a date, we should send in YYYY-MM-DD format
        
        // TEST
        _ = serviceProvider.getLatestInterests(date:Date.init(timeIntervalSinceReferenceDate:0.0))
        
        // POST CONDITIONS
        XCTAssertNotNil(network.url)
        if let sent = network.url {
            XCTAssertTrue((sent.query ?? "").contains("date=2001-01-01"))
        }
    }
    
}

class FlickrServiceClientTests: XCTestCase {
    
    class MockDataProvider: RawFlickrService{
        
        func loadData(fromFile name:String) -> Promise<Data>{
            let testAssets = Bundle.init(identifier: "co.uk.ash.HueInspiredTests")!
            let path: String! = testAssets.path(forResource: name, ofType: "json")
            let f = FileHandle(forReadingAtPath: path)!
            return Promise(value:f.readDataToEndOfFile())
        }
        
        func getLatestInterests(date:Date?, page:Int=1) -> Promise<Data> {
            return loadData(fromFile:"testData_flickr_latest")

        }
        func getPhoto(_ resource: FlickrPhotoResource) -> Promise<Data>{
            return loadData(fromFile:"testData_flickr_latest")
        }
    }
    
    func test_getLatest(){
        let e = expectation(description: "Keep all Palettes in Context")
        
        let client = FlickrServiceClient(serviceProvider: MockDataProvider())
        client.getLatestInterests(date:nil).then { (items:[FlickrPhotoResource]) -> () in
            XCTAssertEqual(items.first?.id, "32264529073")
            e.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)

        
    }
    
}
