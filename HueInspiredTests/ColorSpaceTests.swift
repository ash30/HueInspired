//
//  ColorSpaceTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 08/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import simd
@testable import HueInspired


class ColorSpaceConversionCIELABTests: XCTestCase {
    
    let whitePoint = vector_double3(0.95047, 1.00, 1.08883)
    let tolerance = 0.1
    
    func mapSRGB_TO_LAB(_ a: vector_double3) -> vector_double3{
        let colorXYZ = SRGB_TO_XYZ(a)
        return XYZ_TO_CIELAB(colorXYZ, referenceWhite: whitePoint)
    }
    
    func testZero() {
        let colorSRGB = vector_double3(0,0,0)
        let referenceLAB = vector_double3(0,0,0)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
        
    }
    
    func testMidpoint() {
        let colorSRGB = vector_double3(0.5, 0.5, 0.5)
        let referenceLAB = vector_double3(53.389, 0, 0)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }
    
    func testMidRed() {
        let colorSRGB = vector_double3(0.5, 0.0, 0.0)
        let referenceLAB = vector_double3(24.832, 47.232, 37.143)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }

    func testMidGreen() {
        let colorSRGB = vector_double3(0.0, 0.5, 0.0)
        let referenceLAB = vector_double3(46.052, -51.553, 49.756)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }
    
    func testMidBlue() {
        let colorSRGB = vector_double3(0.0, 0.0, 0.5)
        let referenceLAB = vector_double3(12.890, 47.368, -64.520)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }
    
    func testWhite() {
        let colorSRGB = vector_double3(1.0, 1.0, 1.0)
        let referenceLAB = vector_double3(100.000, 0, 0)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }
    
}
