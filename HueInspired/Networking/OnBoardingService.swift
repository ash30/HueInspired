//
//  OnBoardingService.swift
//  HueInspired
//
//  Created by Ashley Arthur on 17/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class OnBoardingService {
    
    /*
        Centralised location for onboarding logic.
        The service listens for a custom notification indicating the rootview controller has been set.
        Once in place, queries its preferences dependency for persistented first launch flag and acts
     
    */
    
    // MARK: PUBLIC 
    
    var preferences: PreferenceRegistry
    var factory: OnBoardingPageViewControllerFactory?
    
    // MARK: PRIVATE
    
    private static let isInitialLaunchKey = "isInitialLaunchKey"
    
    // MARK: INITS
    
    init(preferences: PreferenceRegistry) {
        self.preferences = preferences
    }
    
    // MARK: TARGET ACTIONS
    
    @objc public func presentOnBoardingViewController(_ notification:NSNotification){
        guard
            let factory = factory,
            let info = notification.userInfo,
            let vc = info[UIWindow.windowAssignRootViewControllerUserInfoKey] as? UIViewController
        else{
            return
        }
        
        if preferences.get(forKey: OnBoardingService.isInitialLaunchKey) == 0 {
            let onboardingVC = factory()
            vc.present(onboardingVC, animated: true, completion: {
                self.preferences.set(1, forKey: OnBoardingService.isInitialLaunchKey)
            })
        }
    }
    
    
}
