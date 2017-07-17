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

        // SETUP ROOT VIEW CONTROLLER
        
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container.resolver)
        let vc = storyboard.instantiateInitialViewController()!
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
        DispatchQueue.main.async { [weak self] _ in
            NotificationCenter.default.post(name: UIWindow.windowDidAssignRootViewController, object: self?.window, userInfo: ["viewController":vc])
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // For Debug Purposes, clear out persistence data
        
        clearDatabaseContent(persistenceContainer:  container.resolver.resolve(NSPersistentContainer.self)!)

        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
}

// DEBUG Method to clear test content 
func clearDatabaseContent(persistenceContainer:NSPersistentContainer){
    
    for entitiy in [CDSColor.self, CDSColorPalette.self, CDSImageSource.self] as [NSManagedObject.Type] {
        
        let fetchRequest = entitiy.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistenceContainer.persistentStoreCoordinator.execute(
                deleteRequest, with: persistenceContainer.viewContext
            )
            
        } catch let error as NSError {
            let e = error
            print(e)
        }
    }
    
}

