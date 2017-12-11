//
//  OnBoardingPageViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 25/08/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest

import Foundation
import UIKit
import FBSnapshotTestCase

@testable import HueInspired

class OnboardingPageViewControllerTests: FBSnapshotTestCase {
    
    // MARK: HELPERS
    
    func setupPageViewController() -> OnBoardingPageViewController {
        let storyBoard = UIStoryboard.init(name: "Onboarding", bundle: nil)
        let vc = storyBoard.instantiateInitialViewController() as! OnBoardingPageViewController
        vc.view.backgroundColor = UIColor.red
        return vc
    }
    
    func setupContentViewController(image: UIImage, title:String, blurb:String) -> OnBoardingContentViewController {
        let storyBoard = UIStoryboard.init(name: "Onboarding", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "OnBoardingContentViewController") as! OnBoardingContentViewController
        vc.image = image
        vc.cardTitle = title
        vc.blurb = blurb
        return vc
    }
    
    // MARK: LIFE CYCLE
    
    override func setUp() {
        super.setUp()
        //self.recordMode = true
    }
    
    // TESTS
    
    func test_contentViewController(){
        let sut = setupContentViewController(image:#imageLiteral(resourceName: "testImage512"),title:"test",blurb:"Content")
        FBSnapshotVerifyView(sut.view)
    }
    
    func test_pageViewController_withContent(){
        let contentVC = setupContentViewController(image:#imageLiteral(resourceName: "testImage512"),title:"test",blurb:"Content")
        let sut = setupPageViewController()
        sut.contentViewControllers = [contentVC]
        
        FBSnapshotVerifyView(sut.view)
    }
    
    func test_contentViewController_largeCopy(){
        let sut = setupContentViewController(image:#imageLiteral(resourceName: "testImage512"),title:"test",blurb:MockData.content)
        FBSnapshotVerifyView(sut.view)
    }
}
