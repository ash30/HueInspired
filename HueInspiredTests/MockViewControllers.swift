//
//  MockViewControllers.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
@testable import HueInspired

class MockPaletteViewController: PaletteTableViewController {
    override var currentDisplayState: PaletteTableViewController.DisplayState {
        didSet{
            return // don't notify UIViews
        }
    }
}

class MockDetailViewController:UserPaletteDetails {
    var data: UserPaletteDataSource? = nil
}
