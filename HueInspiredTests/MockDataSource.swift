//
//  MockDataSource.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import FBSnapshotTestCase
@testable import HueInspired


class MockDataSource: UserPaletteDataSource {
    
    private var testData: [(String,[UserOwnedPalette])] = []
    
    var observer: DataSourceObserver?
    
    var sections: [(String, Int)] {
        return testData.map {
            return ($0.0, $0.1.count)
        }
    }
    let id:Int
    
    convenience init(testData:[UserOwnedPalette], id:Int=0){
        self.init(sections: [("",testData)], id:id)
    }
    
    init(sections:[(String,[UserOwnedPalette])], id:Int=0){
        self.testData = sections
        self.id = id
    }

    
    
    // MARK: DATA SOURCE
    
    func getElement(at index:Int, section sectionIndex:Int) -> UserOwnedPalette? {
        return testData[sectionIndex].1[index]
    }
    
    func getElement(at index:Int, section sectionIndex:Int) -> ColorPalette? {
        return nil // not in use
    }
    
}

extension MockDataSource {
    
    class func create(with testData:[DiscreteRGBAColor]) -> MockDataSource {
        return MockDataSource(testData: [ImmutablePalette(name: nil, colorData: testData, image: nil, guid: nil)])
    }
    
}
