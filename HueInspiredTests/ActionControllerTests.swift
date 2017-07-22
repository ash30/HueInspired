//
//  ActionControllerTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import HueInspired

class ActionControllerTests: FBSnapshotTestCase {
    
    func setupViewController(childVC:UIViewController? = nil) -> ActionContainer {
        let sut = ActionContainer()
        if let childVC = childVC {
            sut.addChildViewController(childVC)
        }
        _ = sut.view // Force views to load
        return sut
    }
    
    var defaultChildVC:UIViewController {
        let vc = UIViewController()
        _ = vc.view
        vc.view.backgroundColor = UIColor.red
        return vc
    }
    
    // MARK: LIFE CYCLE
    
    override func setUp() {
        super.setUp()
        //self.recordMode = true
    }
    
    func testSettingConfigBeforeViewIsLoaded() {
        // Before view is loaded, updateDisplay method should be noop
        let sut = ActionContainer()
        sut.actionButtonText = "test"
    }
    
    func testExample_defaultContainment() {
        // Child View controller should be full frame, and no overlaid button
        let sut = setupViewController(childVC:defaultChildVC)
        FBSnapshotVerifyView(sut.view)
    }
    
    func testExample_actionNonNil() {
        // VC Action button should show when callback is assigned
        let sut = setupViewController(childVC:defaultChildVC)
        sut.action = { _ in
            print("Test")
        }
        FBSnapshotVerifyView(sut.view)
    }
    
    func testExample_ButtonText_short() {
        let sut = setupViewController(childVC:defaultChildVC)
        sut.action = { _ in
            print("Test")
        }
        sut.actionButtonText = "+"
        FBSnapshotVerifyView(sut.view)
    }
    
    func testExample_ButtonText_long() {
        let sut = setupViewController(childVC:defaultChildVC)
        sut.action = { _ in
            print("Test")
        }
        sut.actionButtonText = "Really Long Title"
        FBSnapshotVerifyView(sut.view)
    }
    

    
}
