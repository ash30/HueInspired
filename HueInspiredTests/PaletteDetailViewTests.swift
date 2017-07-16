//
//  PaletteDetailViewTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 05/05/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData
import FBSnapshotTestCase
import PromiseKit
@testable import HueInspired


class PaletteDetailViewSnapShotTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    // HELPERS 
    
    func setupDataSource(testData:[DiscreteRGBAColor]) -> MockDataSource{
        return MockDataSource(testData: [ImmutablePalette(name: nil, colorData: testData, image: nil, guid: nil)])
    }
    
    func setupViewController(dataSource:MockDataSource) -> PaletteDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: "PaletteDetail1") as! PaletteDetailViewController
        
        _ = sut.view // Force views to load
        sut.dataSource = Promise(value:dataSource)
        return sut

    }
    
    func test_paletteDetail_SingleColor(){
        
        let dataSource = setupDataSource(testData:[
            SimpleColor.init(r: 255, g: 0, b: 0)
        ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
        
    }
    
    func test_paletteDetail_MultipleOddNumber_Color(){
        
        let dataSource = setupDataSource(testData:[
            SimpleColor.init(r: 255, g: 0, b: 0),
            SimpleColor.init(r: 255, g: 255, b: 0),
            SimpleColor.init(r: 255, g: 0, b: 255)
            ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
        
    }
    
    func test_paletteDetail_MultipleEvenNumber_Color(){
        
        let dataSource = setupDataSource(testData:[
            SimpleColor.init(r: 255, g: 0, b: 0),
            SimpleColor.init(r: 255, g: 255, b: 0),
            SimpleColor.init(r: 255, g: 0, b: 255),
            SimpleColor.init(r: 255, g: 255, b: 255)

            ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
        
    }
    
}
