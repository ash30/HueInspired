//
//  MultipleDataTableViewControllerTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 23/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import HueInspired


class MultipleDataTableViewControllerTests: FBSnapshotTestCase {
    
    func setupTableViewController() -> PaletteTableViewController {
        let sut = PaletteTableViewController()
        sut.tableCell = PaletteTableCell.self
        sut.tableCellHeight = 48
        return sut
        
    }
    
    
    override func setUp() {
        super.setUp()
        self.recordMode = true
    }
    
    func test_segementControlShowsDataSource() {
        let vc = MultipleDataTableViewController()
        
        vc.dataSources = [("Test",MockDataSource(sections: []))]
        _ = vc.view // Force views to load
        FBSnapshotVerifyView(vc.view)
    }
    
    func test_segementControlShowsMultipleDataSource() {
        let vc = MultipleDataTableViewController()
        vc.dataSources = [("Test",MockDataSource(sections: [])),("Test2",MockDataSource(sections: []))]
        _ = vc.view // Force views to load
        FBSnapshotVerifyView(vc.view)
    }
    
    func test_tableViewUsesDataSource() {
        let vc = MultipleDataTableViewController()
        vc.setTableView(setupTableViewController())
        
        vc.dataSources = [("Test",MockDataSource.init(testData: [ImmutablePalette.init(name: "foo", colorData: [SimpleColor.init(r: 255, g: 0, b: 0)], image: nil, guid: nil)]))]
        _ = vc.view // Force views to load
        FBSnapshotVerifyView(vc.view)
    }
    
    func test_tableViewSwitchDataSource() {
        let vc = MultipleDataTableViewController()
        vc.setTableView(setupTableViewController())
        
        vc.dataSources = [
            ("Test",MockDataSource.init(testData: [ImmutablePalette.init(name: "foo", colorData: [SimpleColor.init(r: 255, g: 0, b: 0)], image: nil, guid: nil)]
            )),
            ("Foo",MockDataSource.init(testData: [ImmutablePalette.init(name: "foo", colorData: [SimpleColor.init(r: 0, g: 255, b: 0)], image: nil, guid: nil)]
            ))
        ]
        vc.dataSourceSelection = 1
        _ = vc.view // Force views to load
        FBSnapshotVerifyView(vc.view)
    }
    
    
}
