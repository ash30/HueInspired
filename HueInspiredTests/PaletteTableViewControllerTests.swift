//
//  PaletteTableViewControllerTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest

import Foundation
import FBSnapshotTestCase

@testable import HueInspired

class PaletteTableViewControllerTests: FBSnapshotTestCase {
    
    // MARK: HELPERS
    
    func setupViewController(dataSource:MockDataSource?) -> PaletteTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: "TrendingTable") as! PaletteTableViewController
        sut.tableCell = PaletteTableCell.self
        sut.tableCellHeight = 48
        
        _ = sut.view // Force views to load
        sut.dataSource = dataSource
        return sut
        
    }
    
    // MARK: LIFE CYCLE
    
    override func setUp() {
        super.setUp()
        //self.recordMode = true
    }
    
    // TESTS
    
    func test_paletteTableView_noDataSource(){
        let sut = setupViewController(dataSource:nil)
        FBSnapshotVerifyView(sut.view)
    }
    
    
    // MARK: Palette Configurations
    
    func test_paletteTableView_singleRow_singleColor(){
        
        let dataSource = MockDataSource(testData:[
            ImmutablePalette.init(name: nil, colorData: [SimpleColor.init(r: 255, g: 0, b: 0),], image: nil, guid: nil)
            ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
        
    }
    
    func test_paletteTableView_singleRow_mutlipleEvenColors(){
        
        let colors = [
            SimpleColor.init(r: 0, g: 0, b: 0),
            SimpleColor.init(r: 255, g: 0, b: 0),
            SimpleColor.init(r: 255, g: 255, b: 0),
            SimpleColor.init(r: 255, g: 255, b: 255),
        ]
        
        let dataSource = MockDataSource(testData:[
            ImmutablePalette.init(name: nil, colorData: colors, image: nil, guid: nil)
            ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
    }
    
    func test_paletteTableView_singleRow_mutlipleOddColors(){
        
        let colors = [
            SimpleColor.init(r: 255, g: 0, b: 0),
            SimpleColor.init(r: 255, g: 255, b: 0),
            SimpleColor.init(r: 255, g: 255, b: 255),
            ]
        
        let dataSource = MockDataSource(testData:[
            ImmutablePalette.init(name: nil, colorData: colors, image: nil, guid: nil)
            ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
    }
    
    func test_paletteTableView_multipleRows(){
        
        let dataSource = MockDataSource(testData:[
            ImmutablePalette.init(name: nil, colorData: [SimpleColor(r: 255, g: 0, b: 0),], image: nil, guid: nil),
            ImmutablePalette.init(name: nil, colorData: [SimpleColor(r: 0, g: 255, b: 0),], image: nil, guid: nil),
            ImmutablePalette.init(name: nil, colorData: [SimpleColor(r: 0, g: 0, b: 255),], image: nil, guid: nil)
            ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
    }
    
    // MARK: SECTIONS
    
    func test_paletteTableView_emptySection(){
        
        let dataSource = MockDataSource(sections:[
            ("First Section", []),
            ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
    }
    
    func test_paletteTableView_emptyDataSource(){
        
        let dataSource = MockDataSource(sections:[])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
    }
    
    func test_paletteTableView_multipleSections(){
        
        let palette = ImmutablePalette(name:nil, colorData: [SimpleColor(r: 255, g: 0, b: 0)], image: nil, guid: nil)
        
        let dataSource = MockDataSource(sections:[
            ("First Section", [palette]),
            ("Second Section", [palette])
            ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
    }
    
    func test_paletteTableView_sectionWithoutTitle(){
        
        let palette = ImmutablePalette(name:nil, colorData: [SimpleColor(r: 255, g: 0, b: 0)], image: nil, guid: nil)
        
        let dataSource = MockDataSource(sections:[
            ("", [palette]),
            ("", [palette])
            ])
        let sut = setupViewController(dataSource:dataSource)
        FBSnapshotVerifyView(sut.view)
    }
    
    // MARK: HEADERs
    
    func test_tableHeader_displaysCollectionName(){
        let sut = setupViewController(dataSource:nil)
        sut.paletteCollectionName = "TESTING"
        FBSnapshotVerifyView(sut.view)
    }
    
    // MARK: DISPLAY STATE
//    func test_currentDisplayState_pending(){
//        // FIXME: Not capturing animation
//        let sut = setupViewController(dataSource:nil)
//        sut.currentDisplayState = .pending
//        FBSnapshotVerifyView(sut.view)
//    }
//    

    
    
    
}
