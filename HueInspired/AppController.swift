//
//  mainFlowController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 01/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ViewControllerFactory {
    
    static private func loadFromStoryBoard(id:String, storyBoardName:String = "Main") -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        return vc
    }
    
    // FIXME: COPY PASTA 
    
    func showPalettes(application: AppController, dataSource:CoreDataPaletteSpecDataSource) -> UIViewController {
        let vc = ViewControllerFactory.loadFromStoryBoard(id: "PaletteTable1") as! PaletteTableViewController
        let controller = PaletteCollectionController(appController: application, viewModel: dataSource, viewControllerFactory: self)
        vc.delegate = controller
        vc.dataSource = dataSource
        dataSource.favouritesManager = application.favouriteManager

        // FIXME: THE VC SHOULD DO THIS AND THEN ACTIVITY VIEW THE SYNC
        dataSource.syncData()

        return vc
    }
    
    func showPalette(application: AppController, dataSource:CoreDataPaletteSpecDataSource) -> UIViewController {
        let vc = ViewControllerFactory.loadFromStoryBoard(id: "PaletteDetail1") as! PaletteDetailViewController
        let controller = PaletteCollectionController(appController: application, viewModel: dataSource, viewControllerFactory: self)
        vc.delegate = controller
        vc.dataSource = dataSource
        dataSource.favouritesManager = application.favouriteManager
        
        // FIXME: THE VC SHOULD DO THIS AND THEN ACTIVITY VIEW THE SYNC
        dataSource.syncData()
        
        return vc
    }
    
}




class AppController {
    
    // MARK: PROPERTIES
    
    internal var persistentContainer: NSPersistentContainer
    var favouriteManager: FavouritesManager
    var paletteManager: PaletteManager
    
    
    // MARK: INIT
    
    init?(){
        // Setup Persistence layer
        persistentContainer = NSPersistentContainer(name: "HueInspired")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // Setup Sub System Controllers
        // FIXME: NEED TO HANDLE POSSIBLE INIT FAIL
        favouriteManager = FavouritesManager(context: persistentContainer.viewContext)!
        paletteManager = PaletteManager(context: persistentContainer.viewContext)
    }

    // MARK: METHODs 
    
    func start(window: UIWindow){
        
        // Setup Root View controller

        let rootViewContoller: UIViewController = UITabBarController()
        defer {
            window.rootViewController = rootViewContoller
            window.makeKeyAndVisible()
        }
        
        let factory = ViewControllerFactory()
        let paletteVC = factory.showPalettes(
            application: self, dataSource: CoreDataPaletteSpecDataSource(data: favouriteManager.getFavourites())
        )
        for vc in [paletteVC]{
            let nav = UINavigationController()
            nav.setViewControllers([vc], animated: false )
            rootViewContoller.addChildViewController(nav)
        }
    }
    
}
