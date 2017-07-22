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


class ColorSpaceConversionSRGBTests: XCTestCase {
    
    let whitePoint = vector_double3(0.95047, 1.00, 1.08883)
    let tolerance = 0.1
    
    func mapSRGB_TO_LAB(_ a: vector_double3) -> vector_double3{
        let colorXYZ = SRGB_TO_XYZ(a)
        return XYZ_TO_CIELAB(colorXYZ, referenceWhite: whitePoint)
    }
    
    func mapLAB_TO_SRGB(_ a: vector_double3) -> vector_double3{
        let colorXYZ = CIELAB_TO_XYZ(a, referenceWhite: whitePoint)
        return XYZ_TO_SRGB(colorXYZ)
    }
    
    /*
        Test color conversion between sRGB space to LAB and Back again
    */
    
    func testZero_SRGB_TO_LAB() {
        let colorSRGB = vector_double3(0,0,0)
        let referenceLAB = vector_double3(0,0,0)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
        
    }
    
    func testZero_LAB_TO_SRGB() {
        let referenceSRGB = vector_double3(0,0,0)
        let colorLAB = vector_double3(0,0,0)
        let result = mapLAB_TO_SRGB(colorLAB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceSRGB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceSRGB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceSRGB.z, accuracy:tolerance)
        
    }
    
    func testMidpoint_SRGB_TO_LAB() {
        let colorSRGB = vector_double3(0.5, 0.5, 0.5)
        let referenceLAB = vector_double3(53.389, 0, 0)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }
    
    func testMidpoint_LAB_TO_SRGB() {
        let referenceSRGB = vector_double3(0.5, 0.5, 0.5)
        let colorLAB = vector_double3(53.389, 0, 0)
        let result = mapLAB_TO_SRGB(colorLAB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceSRGB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceSRGB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceSRGB.z, accuracy:tolerance)
    }
    
    
    func testMidRed_SRGB_TO_LAB() {
        let colorSRGB = vector_double3(0.5, 0.0, 0.0)
        let referenceLAB = vector_double3(25.419, 47.910, 37.906)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }

    func testMidGreen_SRGB_TO_LAB() {
        let colorSRGB = vector_double3(0.0, 0.5, 0.0)
        let referenceLAB = vector_double3(46.052, -51.553, 49.756)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }
    
    func testMidBlue_SRGB_TO_LAB() {
        let colorSRGB = vector_double3(0.0, 0.0, 0.5)
        let referenceLAB = vector_double3(12.890, 47.368, -64.520)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }
    
    func testWhite_SRGB_TO_LAB() {
        let colorSRGB = vector_double3(1.0, 1.0, 1.0)
        let referenceLAB = vector_double3(100.000, 0, 0)
        let result = mapSRGB_TO_LAB(colorSRGB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceLAB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceLAB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceLAB.z, accuracy:tolerance)
    }
    
    func testWhite_LAB_TO_SRGB() {
        let referenceSRGB = vector_double3(1.0, 1.0, 1.0)
        let colorLAB = vector_double3(100.000, 0, 0)
        let result = mapLAB_TO_SRGB(colorLAB)
        
        XCTAssertEqualWithAccuracy(result.x, referenceSRGB.x, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.y, referenceSRGB.y, accuracy:tolerance)
        XCTAssertEqualWithAccuracy(result.z, referenceSRGB.z, accuracy:tolerance)
    }
    
}
