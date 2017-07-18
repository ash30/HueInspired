//
//  ViewControllerAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import UIKit
import CoreData

class ViewControllerAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(UIAlertController.self, name:"CreationMenu") { r in
            let controller = UIAlertController(title:nil, message:nil, preferredStyle:.actionSheet)
            return controller
        }
        
        // MARK: ROOT VIEW
        
        container.storyboardInitCompleted(RootViewController.self) { r, c in
            c.controller = r.resolve(RootViewControllerPaletteCreatorDelegate.self)
        }
        
        container.register(RootViewControllerPaletteCreatorDelegate.self) { r in
            
            return RootViewControllerPaletteCreatorDelegate(
                factory: r.resolve(ColorPaletteDataSourceFactory.self, name:"Background")!
            )
        }
        
        // MARK: TABLE VCs
        
        container.storyboardInitCompleted(PaletteTableViewController.self, name: "TrendingTable"){ r, vc in
            
            // DEPS
            let persistentData = r.resolve(NSPersistentContainer.self)!
            
            // Delgate
            vc.delegate = r.resolve(TrendingPaletteDelegate.self)!
            
            // Data Source
            let coreDataController = r.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Trending", argument:persistentData.viewContext)!
            let dataSource = r.resolve(CoreDataPaletteDataSource.self, argument:coreDataController)!
            vc.dataSource = dataSource
            dataSource.observer = vc
            
            // VC Config
            vc.paletteCollectionName = "HueInspired"
            
            do{
                try dataSource.syncData()
            }
            catch {
                vc.report(error:error)
            }
        }
        
        container.storyboardInitCompleted(PaletteTableViewController.self, name: "FavouritesTable"){ r, vc in
            
            // DEPS
            let persistentData = r.resolve(NSPersistentContainer.self)!
            
            // Delgate
            vc.delegate = r.resolve(PaletteFavouritesDelegate.self)!
            
            // Data Source
            let coreDataController = r.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Favs", argument:persistentData.viewContext)!
            let dataSource = r.resolve(CoreDataPaletteDataSource.self, argument:coreDataController)!
            vc.dataSource = dataSource
            dataSource.observer = vc
            
            // VC Config
            vc.paletteCollectionName = "Favourites"
            
            do{
                try dataSource.syncData()
            }
            catch {
                vc.report(error:error)
            }
        }
        
        // MARK: TABLE DELEGATES
        
        container.register(PaletteFavouritesDelegate.self){ (r:Resolver) in
            return PaletteFavouritesDelegate(factory:r.resolve(ColorPaletteDataSourceFactory.self)!)
        }
        
        container.register(TrendingPaletteDelegate.self){ (r:Resolver) in
            let persistentData: NSPersistentContainer = r.resolve(NSPersistentContainer.self)!
            let bkgroundCtx = persistentData.newBackgroundContext()
            
            // We can possibly recreate existing palettes when syncing latest
            // This will trip validation rules on Image Source duplication
            // Existing Palettes take precedence
            bkgroundCtx.mergePolicy = NSMergePolicy.rollback
            
            return TrendingPaletteDelegate.init(
                factory:r.resolve(ColorPaletteDataSourceFactory.self, argument:bkgroundCtx)!,
                ctx:bkgroundCtx,  // We want to new palette syncing to be done on bkground ctx
                remotePalettes: r.resolve(FlickrTrendingPhotoService.self)! as TrendingPaletteService
            )
        }
        
        // MARK: DETAIL VIEW CONTROLLER
        
        container.storyboardInitCompleted(PaletteDetailViewController.self){ (r:Resolver, vc:PaletteDetailViewController) in
            let persistentData: NSPersistentContainer = r.resolve(NSPersistentContainer.self)!
            let delegate = r.resolve(UserManagedPaletteDetailDelegate.self, argument:persistentData.viewContext)!
            vc.delegate = delegate
        }
        
        container.register(UserManagedPaletteDetailDelegate.self) { (r:Resolver, ctx:NSManagedObjectContext) in
            let favs = try? PaletteFavourites.getSelectionSet(for: ctx)
            return UserManagedPaletteDetailDelegate(context:ctx)
        }

    }
    
    
}
