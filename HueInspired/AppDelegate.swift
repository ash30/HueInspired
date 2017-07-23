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
    let container: Assembler = Assembler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // SETUP WINDOW
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // SETUP OBJECT GRAPH

        container.apply(assemblies: [ServiceAssembly(), ViewControllerAssembly(), DataSourceAssembly()])
        
        if (ProcessInfo.processInfo.arguments.contains(ApplicationArgs.DISABLE_PERSIST.rawValue)) {
            container.apply(assembly: PersistenceAssembly(debug:true))
        }
        else {
            container.apply(assembly: PersistenceAssembly(debug:false))
        }
        
        if (ProcessInfo.processInfo.arguments.contains(ApplicationArgs.DATA_CLEAN.rawValue)) {
            PersistenceAssembly.clearUserPreferences(bundle: nil)
            PersistenceAssembly.clearDatabaseContent(persistenceContainer: container.resolver.resolve(NSPersistentContainer.self)!)
        }
        
        if (ProcessInfo.processInfo.arguments.contains(ApplicationArgs.DISABLE_NETWORK.rawValue)) {
            //
        }
        else {
            container.apply(assembly: NetworkAssembly())
        }
        
        if (ProcessInfo.processInfo.arguments.contains(ApplicationArgs.DISABLE_ONBOARD.rawValue)) {
            
        }
        else {
            container.apply(assembly: OnBoardingAssembly(window:window!))
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

