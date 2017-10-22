//
//  OnBoardingAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 17/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import SwinjectStoryboard

typealias OnBoardingContentViewControllerFactory = (_ image: UIImage,_ title:String,_ content:String) -> UIViewController
typealias OnBoardingPageViewControllerFactory = () -> OnBoardingPageViewController


class OnBoardingAssembly: Assembly {
    
    weak var window: UIWindow?
    
    init(window:UIWindow?) {
        self.window = window
    }
    
    func assemble(container: Container) {
        
        // MARK: SERVICE
        
        container.register(OnBoardingService.self) { r in
            let service = OnBoardingService(preferences: r.resolve(PreferenceRegistry.self)!)
            service.factory = r.resolve(OnBoardingPageViewControllerFactory.self)!
            return service
        }.inObjectScope(.container)
        
        
        // MARK: FACTORY 
        
        container.register(OnBoardingPageViewControllerFactory.self) { r in
            return { () -> OnBoardingPageViewController in
                let storyBoard = SwinjectStoryboard.create(name: "Onboarding", bundle: nil, container: r)
                let vc = storyBoard.instantiateInitialViewController() as! OnBoardingPageViewController
                return vc
            }
        }
        
        container.register(OnBoardingContentViewControllerFactory.self) { r in
            return {(i:UIImage,title:String,content:String) -> UIViewController in
                
            let storyBoard = SwinjectStoryboard.create(name: "Onboarding", bundle: nil, container: r)
            let vc = storyBoard.instantiateViewController(withIdentifier: "OnBoardingContentViewController") as! OnBoardingContentViewController
            vc.image = i
            vc.cardTitle = title
            vc.blurb = content
                
            return vc
                
            }
        }
        
        // MARK: VIEW CONTROLLERS
        
        container.storyboardInitCompleted(OnBoardingPageViewController.self) { (r, vc:OnBoardingPageViewController) in
            
            vc.view.backgroundColor = UIColor.white
            
            let factory = r.resolve(OnBoardingContentViewControllerFactory.self)!
            
            var content = [
                (UIImage.init(named: "testImage512")!, "Color Clash?", "Picking Colors that works together is hard..."),
                (UIImage.init(named: "testImage512")!, "Get Hue Inspired", "Transform photos into colors and see what works in real life"),
                (UIImage.init(named: "testImage512")!,"Globally Inspired","Still Stuck? Use our curated photos from around the world")

            ].map { factory($0,$1,$2) }
            
            vc.contentViewControllers = content
        }
        
    }
    
    func loaded(resolver: Resolver) {
        
        // Register OnBoarding Services for
        let manager = resolver.resolve(OnBoardingService.self)!
        
        NotificationCenter.default.addObserver(manager, selector: #selector(manager.presentOnBoardingViewController), name:UIWindow.windowDidAssignRootViewController , object: window)
        
        
        // Set Appearances
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [OnBoardingPageViewController.self])
        
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        
    }
    
}
