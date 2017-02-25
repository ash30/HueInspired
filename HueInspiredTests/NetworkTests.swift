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
    
    // FIXME: SET CONFIG MANUALLY!
    func test_url_forMethod_Interseting(){
        
        let _ = serviceProvider?.getLatestInterests()
        let expected = "https://api.flickr.com/services/rest?method=flickr.interestingness.getList&api_key=21d84efb405c7ff44a32210f66514819&format=json"
        XCTAssertEqual(network?.url?.absoluteString ?? "", expected)
        
    }
    
    
}
