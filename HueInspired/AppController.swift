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
    
    internal func setupPaletteViewController(application: AppController, dataSource:CoreDataPaletteSpecDataSource, vcIdent:String) -> UIViewController {
        
        let vc = ViewControllerFactory.loadFromStoryBoard(id: vcIdent)
        let controller = PaletteCollectionController(appController: application, viewModel: dataSource, viewControllerFactory: self)
        
        guard let paletteVC = vc as? PaletteViewController else{
            return vc
        }
        paletteVC.delegate = controller
        paletteVC.dataSource = dataSource
        dataSource.favouritesManager = application
        
        // FIXME: THE VC SHOULD DO THIS AND THEN ACTIVITY VIEW THE SYNC
        dataSource.syncData()
        
        return vc
    }
    
    func showPaletteCollection(application: AppController, dataSource:CoreDataPaletteSpecDataSource) -> UIViewController {
        return setupPaletteViewController(application: application, dataSource: dataSource, vcIdent: "PaletteTable1")
    }
    
    func showPalette(application: AppController, dataSource:CoreDataPaletteSpecDataSource) -> UIViewController {
        return setupPaletteViewController(application: application, dataSource: dataSource, vcIdent: "PaletteDetail1")
    }

    
}

class AppController: FavouritesManager, LocalPaletteManager {
    
    // MARK: PROPERTIES
    var persistentData: NSPersistentContainer {
        return persistentContainer
    }
    
    // DATA LAYER
    internal var persistentContainer: NSPersistentContainer
    
    // NETWORK LAYER
    internal var network: NetworkManager = {
        return HTTPClient.init(session: URLSession.shared)
    }()
    
    // FIXME: BETTER NAME PLEASE!
    var latestPaletteService: RemotePaletteService
    
    // MARK: INIT
    
    init?(){
        // Setup Persistence layer
        persistentContainer = NSPersistentContainer(name: "HueInspired")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // Setup defualt merge policy 
        persistentContainer.viewContext.mergePolicy = NSMergePolicy.rollback
        
        // SETUP NETWORK SERVICES
        
        // FIXME: Please make this less ugly ...
        latestPaletteService = RemotePaletteService(photoService: FlickrServiceClient(serviceProvider: FlickrServiceProvider(networkManager: network, serviceConfig: FlickServiceConfig())))
        
        
        // DO? FIXME! Should be in root VC 
        syncLatestPalettes()
    }

    // MARK: METHODs 
    
    func syncLatestPalettes(){
        
        let latest = latestPaletteService.getLatest().then { (palettes: [ColorPalette]) in
            self.replace(with: palettes)
        }.catch { (error:Error) in
            
            // Need to do something with error, probably give error'd promise to 
            // caller
            
        }
        
    }
    
    func start(window: UIWindow){
        
        // Setup Root View controller

        let rootViewContoller: UIViewController = UITabBarController()
        defer {
            window.rootViewController = rootViewContoller
            window.makeKeyAndVisible()
        }
        
        // Test
        let request: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        
        let factory = ViewControllerFactory()
        let paletteVC = factory.showPaletteCollection(
            application: self, dataSource: CoreDataPaletteSpecDataSource(data: getPalettes())
        )
        paletteVC.title = "Popular"

        // FIXME: HANDLE ERROR
        let favouritesController = try! getFavourites(for: persistentContainer.viewContext).fetchMembers()!
        let favouritesVC = factory.showPaletteCollection(
                application: self, dataSource: CoreDataPaletteSpecDataSource(data: favouritesController)
        )
        favouritesVC.title = "Favourites"

        for vc in [paletteVC, favouritesVC]{
            let nav = UINavigationController()
            nav.title = vc.title
            nav.setViewControllers([vc], animated: false )
            rootViewContoller.addChildViewController(nav)
        }
    }
    
}
