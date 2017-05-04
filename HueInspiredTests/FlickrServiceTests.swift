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
    
    var network: MockNetworkManager?
    var serviceProvider: FlickrServiceProvider?
    
    override func setUp() {
        super.setUp()
        network = MockNetworkManager()
        serviceProvider = FlickrServiceProvider.init(networkManager: network!, serviceConfig: FlickServiceConfig())
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
        
        func getLatestInterests() -> Promise<Data> {
            return loadData(fromFile:"testData_flickr_latest")

        }
        func getPhoto(_ resource: FlickrPhotoResource) -> Promise<Data>{
            return loadData(fromFile:"testData_flickr_latest")
        }
    }
    
    func test_getLatest(){
        let e = expectation(description: "Keep all Palettes in Context")
        
        let client = FlickrServiceClient(serviceProvider: MockDataProvider())
        client.getLatestInterests().then { (items:[FlickrPhotoResource]) -> () in
            XCTAssertEqual(items.first?.id, "32264529073")
            e.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)

        
    }
    
}
