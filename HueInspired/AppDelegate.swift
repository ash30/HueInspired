//
//  AppDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import UIKit
import CoreData
import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var container: Assembler!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // SETUP WINDOW
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // SETUP OBJECT GRAPH

        
        if ProcessInfo.processInfo.arguments.contains("TESTING") {
            //pass
            
        } else {
            container = Assembler([
                OnBoardingAssembly(window:window!),
                PersistenceAssembly(),
                NetworkAssembly(),
                ServiceAssembly(),
                DataSourceAssembly(),
                ViewControllerAssembly(),
            ])
        }
        
        if ProcessInfo.processInfo.arguments.contains("TESTING-Clean") {
            PersistenceAssembly.clearUserPreferences(bundle: nil)
            PersistenceAssembly.clearDatabaseContent(persistenceContainer: container.resolver.resolve(NSPersistentContainer.self)!)
        }

        // SETUP ROOT VIEW CONTROLLER
        
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container.resolver)
        let vc = storyboard.instantiateInitialViewController()!
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
        DispatchQueue.main.async { [weak self] _ in
            NotificationCenter.default.post(name: UIWindow.windowDidAssignRootViewController, object: self?.window, userInfo: [UIWindow.windowAssignRootViewControllerUserInfoKey:vc])
        }
        return true
    }

}

