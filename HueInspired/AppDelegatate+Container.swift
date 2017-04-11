//
//  AppDelegatate+Container
//  HueInspired
//
//  Created by Ashley Arthur on 01/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Swinject
import SwinjectStoryboard

extension AppDelegate {
    
    static let container: Container = {
    
        let container = Container()
        
        container.register(NSPersistentContainer.self) { _ in
            
            let persistentData = NSPersistentContainer(name: "HueInspired")
            persistentData.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            persistentData.viewContext.mergePolicy = NSMergePolicy.rollback
            return persistentData
            
            }.inObjectScope(.container)
        
        container.register(NetworkManager.self){ _ in
            HTTPClient.init(session: URLSession.shared)
            }.inObjectScope(.container)
        
        
        // ROOT VIEW
        container.storyboardInitCompleted(RootViewController.self) { r, c in
            c.controller = r.resolve(RootViewControllerDelegate.self)
        }
        
        container.register(RootViewControllerDelegate.self) { r in
            RootController(
                persistentData:r.resolve(NSPersistentContainer.self)!,
                detailControllerFactory: { (ctx:NSManagedObjectContext) -> PaletteDetailController in
                    return r.resolve(PaletteDetailController.self, argument:ctx)!
            }
            )
        }
        
        // TABLE VCs
        
        container.storyboardInitCompleted(PaletteTableViewController.self, name: "TrendingTable"){ r, vc in
            
            let persistentData = r.resolve(NSPersistentContainer.self)!
            let controller = r.resolve(PaletteCollectionController.self, argument:persistentData.viewContext)!
            vc.delegate = controller
            vc.dataSource = controller.dataSource as! PaletteSpecDataSource  //FIXME!
        }
        
        container.storyboardInitCompleted(PaletteTableViewController.self, name: "FavouritesTable"){ r, vc in
            
            let persistentData = r.resolve(NSPersistentContainer.self)!
            let controller = r.resolve(PaletteFavouritesController.self, argument:persistentData.viewContext)!
            vc.delegate = controller
            vc.dataSource = controller.dataSource as! PaletteSpecDataSource  //FIXME!
        }
        
        // TABLE CONTROLLERS
        
        container.register(PaletteFavouritesController.self){ (r:Resolver, ctx:NSManagedObjectContext) in
            
            let controller = r.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Favs", argument:ctx)!
            let data = r.resolve(CoreDataPaletteDataSource.self, argument:controller)!
            return PaletteFavouritesController(dataSource:data)
            
        }
        
        container.register(PaletteCollectionController.self){ (r:Resolver, ctx:NSManagedObjectContext) in
            // This is really trending palette delegate, better name please
            // We resolve the data source here
            
            let controller = r.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Trending", argument:ctx)!
            let data = r.resolve(CoreDataPaletteDataSource.self, argument:controller)!
            let persistentData: NSPersistentContainer = r.resolve(NSPersistentContainer.self)!
            let bkgroundCtx = persistentData.newBackgroundContext()
            
            // We will possibly recreate existing palettes when syncing latest
            // This will trip validation rules on Image Source duplication
            // Existing Palettes take precedence 
            bkgroundCtx.mergePolicy = NSMergePolicy.rollback
            
            return PaletteCollectionController.init(
                dataSource:data,
                ctx:bkgroundCtx,  // We want to new palette syncing to be done on bkground ctx
                remotePalettes: r.resolve(RemotePaletteService.self)!
            )
        }
        
        
        // NETWORK SERVICES
        
        container.register(RemotePaletteService.self){ r in
            FlickrPaletteSericeAdapter(
                photoService: FlickrServiceClient(
                    serviceProvider: FlickrServiceProvider(
                        networkManager: r.resolve(NetworkManager.self)!, serviceConfig: FlickServiceConfig()
                    )
                )
            )
        }
        
        // DETAIL VIEW
        
        container.storyboardInitCompleted(PaletteDetailViewController.self){ r, vc in
            return vc // noop
        }
        
        container.register(PaletteDetailController.self) { (r:Resolver, ctx:NSManagedObjectContext) in
            let favs = try? PaletteFavourites.getSelectionSet(for: ctx)
            let dataSource = r.resolve(CoreDataPaletteDataSource.self, argument:CDSColorPalette.getPalettes(ctx: ctx))!
            return PaletteDetailController(dataSource:dataSource)
        }
        
        
        // DATA SOURCES
        
        container.register(CoreDataPaletteDataSource.self) { (r:Resolver, data:NSFetchedResultsController<CDSColorPalette>)  in
            let f = try! PaletteFavourites.getSelectionSet(for: data.managedObjectContext)
            return CoreDataPaletteDataSource(data: data, favourites: f)
        }
        
        container.register(NSFetchedResultsController<CDSColorPalette>.self, name:"Favs"){ (r:Resolver, ctx:NSManagedObjectContext) in
            
            let controller = (try! PaletteFavourites.getSelectionSet(for: ctx)).fetchMembers()!
            controller.fetchRequest.sortDescriptors = [ .init(key:#keyPath(CDSColorPalette.creationDate), ascending:false)]
            return controller
        }
        
        container.register(NSFetchedResultsController<CDSColorPalette>.self, name:"Trending"){ (r:Resolver, ctx:NSManagedObjectContext) in
            
            let controller = CDSColorPalette.getPalettes(ctx: ctx)
            controller.fetchRequest.predicate = NSPredicate(
                format: "%K != nil", argumentArray: [#keyPath(CDSColorPalette.source)]
            )
            controller.fetchRequest.sortDescriptors = [
                .init(key:#keyPath(CDSColorPalette.creationDate), ascending:false)
                
            ]
            return controller
        }
        
        return container
    }()

}
