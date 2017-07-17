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

typealias OnBoardingContentViewControllerFactory = (UIImage,String) -> OnBoardingContentViewController
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
            return {(i:UIImage,s:String) -> OnBoardingContentViewController in
                
            let storyBoard = SwinjectStoryboard.create(name: "Onboarding", bundle: nil, container: r)
            let vc = storyBoard.instantiateViewController(withIdentifier: "OnBoardingContentViewController") as! OnBoardingContentViewController
                
            vc.image = i
            vc.blurb = s
            return vc
                
            }
        }
        
        // MARK: VIEW CONTROLLERS
        
        container.storyboardInitCompleted(OnBoardingPageViewController.self) { (r, vc:OnBoardingPageViewController) in
            
            let factory = r.resolve(OnBoardingContentViewControllerFactory.self)!
            
            let content = [
            
            (UIImage.init(named: "testImage512")!, "ONBOARDING DEMO"),
            (UIImage.init(named: "testImage512")!, "ONBOARDING DEMO2")
            
            ]
            vc.contentViewControllers = content.map { factory($0,$1) }
        }
        
    }
    
    func loaded(resolver: Resolver) {
        
        // Register OnBoarding Services for
        let manager = resolver.resolve(OnBoardingService.self)!
        
        NotificationCenter.default.addObserver(manager, selector: #selector(manager.presentOnBoardingViewController), name:UIWindow.windowDidAssignRootViewController , object: window)
        
        
        
    }
    
}
