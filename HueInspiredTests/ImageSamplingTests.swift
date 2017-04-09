//
//  ImageSamplingTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import simd
@testable import HueInspired

class ImageSamplingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_1col_512(){
        let image = UIImage(named: "testImage512")!
        let samples = SampleImage(sourceImage: image)!
        XCTAssertEqualWithAccuracy( samples[0].srgb.x , 0.486, accuracy:0.1)
    }
    
    func test_2col_512(){
        let image = UIImage(named: "testImage2Col_512")!
        let samples = SampleImage(sourceImage: image)!
        XCTAssertEqualWithAccuracy( samples[0].srgb.x , 0.486, accuracy:0.1)
    }

}
