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


class AppController {
    
    // MARK: PROPERTIES
    
    // DATA LAYER
    internal var persistentData: NSPersistentContainer
    
    var mainContext: NSManagedObjectContext {
        return persistentData.viewContext
    }
    
    // NETWORK LAYER
    internal var network: NetworkManager = {
        return HTTPClient.init(session: URLSession.shared)
    }()
    
    // SERVICES
    var viewControllerFactory = ViewControllerFactory()
    var favourites: FavouritesManager!
    var localPalettes: LocalPaletteManager!
    var remotePalettes: RemotePaletteService!
    
    
    // MARK: INIT
    
    init?(){
        persistentData = NSPersistentContainer(name: "HueInspired")
        persistentData.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentData.viewContext.mergePolicy = NSMergePolicy.rollback
    }

    
    func start(window: UIWindow){
        
        // Setup Services
        self.favourites = FavouritesManager(dataLayer: persistentData)
        self.localPalettes = LocalPaletteManager(dataLayer: persistentData)
        self.remotePalettes = FlickrPaletteSericeAdapter(
            photoService: FlickrServiceClient(
                serviceProvider: FlickrServiceProvider(
                    networkManager: network, serviceConfig: FlickServiceConfig()
                )
            )
        )
        
        // Setup Root View controller
        let rootViewContoller: UIViewController = viewControllerFactory.showRoot(application: self)
        window.rootViewController = rootViewContoller
        window.makeKeyAndVisible()
    }
    
}
