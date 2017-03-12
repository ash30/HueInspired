//
//  RootViewControllerDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 28/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit
import CoreData

protocol RootViewControllerDelegate {
    func syncLatestPalettes() -> Promise<Bool>
    func didSelectUserImage(viewController:UIViewController, image: UIImage)
    func didLoad(viewController:UIViewController)
}

struct RootController: RootViewControllerDelegate, PaletteSync {
    
    // MARK: PROPERTIES
    var viewControllerFactory: ViewControllerFactory
    var appController: AppController
    
    // MARK: METHODS
    
    func didLoad(viewController:UIViewController){
        
        // Setup Child VCs
        let paletteVC = viewControllerFactory.showPaletteCollection(
            application: appController,
            context:nil,
            title:"Popular"
        )
        paletteVC.tabBarItem = UITabBarItem(title: "Trending", image: UIImage.init(named: "ic_sync")!, selectedImage: nil)
        
        let favouritesVC = viewControllerFactory.showFavourites(
            application: appController,
            context:nil,
            title:"Favourites"
        )
        favouritesVC.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage.init(named: "ic_folder")!, selectedImage: nil)
        
        for vc in [paletteVC, favouritesVC]{
            let nav = UINavigationController()
            nav.title = vc.title
            nav.setViewControllers([vc], animated: false )
            viewController.addChildViewController(nav)
        }
    }
    
    func createDataSource(_ image:UIImage) -> CoreDataPaletteDataSource {
        
        let ctx = appController.persistentData.newBackgroundContext()
        let newPaletteId:NSManagedObjectID?
        var fetch: NSFetchedResultsController<CDSColorPalette>?
        let favs = try? appController.favourites.getSelectionSet(for: ctx)
        
        ctx.performAndWait {
            
            // FIXME: FORCED CAST
            guard
                let palette = ImmutablePalette(withRepresentativeSwatchesFrom: image, name: nil)
            else {
                return
            }
            do{
                let p = CDSColorPalette(context: ctx, palette: palette)
                try ctx.save()
                fetch = CDSColorPalette.getPalettes(ctx: ctx, ids: [p.objectID])
            }
            catch {
                print("error creating palette")
            }
        }
        if let fetch = fetch {
            return CoreDataPaletteDataSource(data: fetch, favourites: favs)
        }
        else {
            // Image creation didn't work, we present a erorred data source so vc 
            // can tell user
            fetch = CDSColorPalette.getPalettes(ctx: ctx)
            let data = CoreDataPaletteDataSource(data: fetch!, favourites: nil)
            data.dataState = .errored(PaletteErrors.paletteCreationFailure)
            return data
        }
        
    }
    
    func didSelectUserImage(viewController:UIViewController, image: UIImage){
        
        let data = createDataSource(image)
        let vc = appController.viewControllerFactory.showPalette(application: appController, dataSource: data)
        viewController.show(vc, sender: nil)
        
    }

}
