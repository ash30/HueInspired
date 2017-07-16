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
    
    private var testData: [UserOwnedPalette] = []
    
    var observer: DataSourceObserver?
    var sections: [(String, Int)] {
        return [("test",self.testData.count)]
    }
    let id:Int
    
    init(testData:[UserOwnedPalette], id:Int=0){
        self.testData = testData
        self.id = id 
    }
    
    // MARK: DATA SOURCE
    
    func getElement(at index:Int, section sectionIndex:Int) -> UserOwnedPalette? {

        guard index < testData.count else {
            return nil
        }
        return testData[index]
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
