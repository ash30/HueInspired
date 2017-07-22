//
//  Base64EncodingTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
@testable import HueInspired

class Base64EncodingTests: XCTestCase {
    
    // Quick Sanity Checks on base 64 string extension
        
    func test_base64Encode(){
        XCTAssertEqual("Man".toBase64(), "TWFu")
    }
    
    func test_base64Encode_padding(){
        XCTAssertEqual("M".toBase64(), "TQ==")
    }
    
    func test_base64Decode(){
        XCTAssertEqual("Man", "TWFu".fromBase64())

    }
    
}
