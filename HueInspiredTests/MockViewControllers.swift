//
//  MockViewControllers.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import XCTest
@testable import HueInspired

class MockPaletteViewController: PaletteTableViewController {
    
    var displayStateChange: XCTestExpectation?
    
    override var currentDisplayState: PaletteTableViewController.DisplayState {
        didSet{
            displayStateChange?.fulfill()
        }
    }
}

class MockDetailViewController:UserPaletteDetails {
    var dataSource: UserPaletteDataSource? = nil
}
