//
//  KDTreeTestes.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import simd
@testable import HueInspired


class KDTreeTestes: XCTestCase {
    
    
    func testTreeCreation() {
        // This should bail long before max depth
        
        let input = [
            vector_double3(1.0, 0.0, 0.0),
            vector_double3(5.0, 0.0, 0.0),
            vector_double3(10.0, 0.0, 0.0)
        ]
        let tree = KDNodeTree.init(points: input)
        XCTAssertNotNil(tree)
    }
    
    
    func testTreeIterator() {

        let input = [
            vector_double3(1.0, 0.0, 0.0),
            vector_double3(5.0, 0.0, 0.0),
            vector_double3(10.0, 0.0, 0.0)
        ]
        let tree = KDNodeTree.init(points: input, maxDepth: 1)!
        
        XCTAssertEqual(
            tree.map { $0 }[0].x ,
            5.0
        )
        XCTAssertEqual(
            tree.map { $0 }[1].x ,
            1.0
        )
        XCTAssertEqual(
            tree.map { $0 }[2].x ,
            10.0
        )

    }
    
    func testSearchNearest_exactMatch() {
        
        let input = [
            vector_double3(1.0, 0.0, 0.0),
            vector_double3(5.0, 0.0, 0.0),
            vector_double3(10.0, 0.0, 0.0)
        ]
        let tree = KDNodeTree.init(points: input, maxDepth: 1)!
        
        let result = tree.searchNearest(vector_double3(1.0, 0.0, 0.0))
        XCTAssertEqual(result.x, 1.0)
    }
    
    func testSearchNearest_inbetween() {
        
        let input = [
            vector_double3(1.0, 0.0, 0.0),
            vector_double3(5.0, 0.0, 0.0),
            vector_double3(10.0, 0.0, 0.0)
        ]
        let tree = KDNodeTree.init(points: input, maxDepth: 1)!
        
        let result = tree.searchNearest(vector_double3(3.6, 0.0, 0.0))
        XCTAssertEqual(result.x, 5.0)
    }
    

    
}
