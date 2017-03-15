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
    

    
    func createPaletteFromUserImage(ctx:NSManagedObjectContext, image:UIImage) -> Promise<NSManagedObjectID> {
        
        let p = Promise<NSManagedObjectID>.pending()
        
        ctx.perform  {
            guard
                let palette = ImmutablePalette(withRepresentativeSwatchesFrom: image, name: nil)
                else {
                    p.reject(PaletteErrors.paletteCreationFailure)
                    return
            }
            do{
                let paletteEntity = CDSColorPalette(context: ctx, palette: palette)
                try ctx.save()
                p.fulfill(paletteEntity.objectID)
            }
            catch {
                p.reject(error)
            }
        }
        return p.promise
    }
    
    func didSelectUserImage(viewController:UIViewController, image: UIImage){
        
        let ctx = appController.persistentData.newBackgroundContext()
        let favs = try? appController.favourites.getSelectionSet(for: ctx)
        let data = CoreDataPaletteDataSource(data: CDSColorPalette.getPalettes(ctx: ctx), favourites: favs)
        
        let event = createPaletteFromUserImage(ctx:ctx, image:image).then { (id:NSManagedObjectID) -> Bool in
            data.replaceOriginalFilter(NSPredicate(format: "self IN %@", [id]))
            return true
        }
        data.syncData(event: event)
        
        let vc = appController.viewControllerFactory.showPalette(application: appController, dataSource: data)
        viewController.show(vc, sender: nil)
        
        
        
    }

}
