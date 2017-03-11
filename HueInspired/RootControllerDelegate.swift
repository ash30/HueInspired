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
        var fetch: NSFetchedResultsController<CDSColorPalette>?
        
        ctx.performAndWait {
            
            // FIXME: FORCED CAST
            let p = CDSColorPalette(context: ctx, palette: ImmutablePalette(withRepresentativeSwatchesFrom: image, name: nil)!)
            fetch = CDSColorPalette.getPalettes(ctx: ctx, ids: [p.objectID])
        }
        
        return CoreDataPaletteDataSource(data: fetch!, favourites: nil)
        
    }
    
    func didSelectUserImage(viewController:UIViewController, image: UIImage){
        
        let data = createDataSource(image)
        let vc = appController.viewControllerFactory.showPalette(application: appController, dataSource: data)
        viewController.show(vc, sender: nil)
        
    }

}
