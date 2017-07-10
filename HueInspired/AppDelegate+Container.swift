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

// MARK: FACTORIES

typealias DetailDataSourceFactory = (NSManagedObjectContext, NSManagedObjectID) -> CoreDataPaletteDataSource

// MARK: DI CONTAINER

extension AppDelegate {
    
    static let container: Container = {
    
        let container = Container()
        
        // MARK: CORE DATA
        
        container.register(NSPersistentContainer.self) { _ in
            
            let persistentData = NSPersistentContainer(name: "HueInspired")
            persistentData.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            persistentData.viewContext.mergePolicy = NSMergePolicy.rollback
            persistentData.viewContext.automaticallyMergesChangesFromParent = true

            return persistentData
            
        }.inObjectScope(.container)
        
        container.register(NetworkManager.self){ _ in
            HTTPClient.init(session: URLSession.shared)
        }.inObjectScope(.container)
        
        
        // MARK: FACTORIES
        
        container.register(DetailDataSourceFactory.self) { r in
            
            let factory: (NSManagedObjectContext, NSManagedObjectID) -> CoreDataPaletteDataSource = {
                
                let controller = r.resolve(
                    NSFetchedResultsController<CDSColorPalette>.self,
                    name:"Detail",
                    arguments:$0,$1
                    )!
                
                let dataSource = r.resolve(CoreDataPaletteDataSource.self, argument:controller)!
                
                return dataSource
            }
            return factory
        }
        
        
        // MARK: ROOT VIEW
        
        container.storyboardInitCompleted(RootViewController.self) { r, c in
            c.controller = r.resolve(RootViewControllerDelegate.self)
        }
        
        container.register(RootViewControllerDelegate.self) { r in
            
            let persistentData = r.resolve(NSPersistentContainer.self)!
            
            return RootController(
                persistentData:r.resolve(NSPersistentContainer.self)!,
                factory: r.resolve(DetailDataSourceFactory.self)!
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
            return PaletteFavouritesDelegate(factory:r.resolve(DetailDataSourceFactory.self)!)
        }
        
        container.register(TrendingPaletteDelegate.self){ (r:Resolver) in            
            let persistentData: NSPersistentContainer = r.resolve(NSPersistentContainer.self)!
            let bkgroundCtx = persistentData.newBackgroundContext()
            
            // We can possibly recreate existing palettes when syncing latest
            // This will trip validation rules on Image Source duplication
            // Existing Palettes take precedence 
            bkgroundCtx.mergePolicy = NSMergePolicy.rollback
            
            return TrendingPaletteDelegate.init(
                factory:r.resolve(DetailDataSourceFactory.self)!,
                ctx:bkgroundCtx,  // We want to new palette syncing to be done on bkground ctx
                remotePalettes: r.resolve(FlickrTrendingPhotoService.self)!
            )
        }
        
        // MARK: DETAIL VIEW CONTROLLER
        
        container.storyboardInitCompleted(PaletteDetailViewController.self){ _, vc in
            return vc // noop
        }
        
        container.register(UserManagedPaletteDetailDelegate.self) { (r:Resolver, ctx:NSManagedObjectContext) in
            let favs = try? PaletteFavourites.getSelectionSet(for: ctx)
            return UserManagedPaletteDetailDelegate(context:ctx)
        }
        
        // MARK: NETWORK SERVICES
        
        container.register(FlickrTrendingPhotoService.self){ r in
            
            let neworkManager: NetworkManager = r.resolve(NetworkManager.self)!
            let photoService = FlickrServiceClient(
                serviceProvider: FlickrServiceProvider(
                    networkManager: neworkManager , serviceConfig: FlickServiceConfig()
                )
            )
            let service = FlickrTrendingPhotoService.init(photoService:photoService, preferences:UserDefaults.standard)
            service.resume()
            return service
        }
        
        // MARK: DATA SOURCES
        
        container.register(CoreDataPaletteDataSource.self) { (r:Resolver, data:NSFetchedResultsController<CDSColorPalette>)  in
            return CoreDataPaletteDataSource(data: data)
        }
        
        container.register(NSFetchedResultsController<CDSColorPalette>.self, name:"Favs"){ (r:Resolver, ctx:NSManagedObjectContext) in
            
            let controller = (try! PaletteFavourites.getSelectionSet(for: ctx)).fetchMembers()!
            controller.fetchRequest.sortDescriptors = [ .init(key:#keyPath(CDSColorPalette.creationDate), ascending:false)]
            return controller
        }
        
        container.register(NSFetchedResultsController<CDSColorPalette>.self, name:"Trending"){ (r:Resolver, ctx:NSManagedObjectContext) in
            
            let controller = CDSColorPalette.getPalettes(ctx: ctx, sectionNameKeyPath: #keyPath(CDSColorPalette.displayCreationDate))
            controller.fetchRequest.predicate = NSPredicate(
                format: "%K != nil", argumentArray: [#keyPath(CDSColorPalette.source)]
            )
            controller.fetchRequest.sortDescriptors = [
                .init(key:#keyPath(CDSColorPalette.creationDate), ascending:false)
                
            ]
            return controller
        }
        
        container.register(NSFetchedResultsController<CDSColorPalette>.self, name:"Detail"){ (r:Resolver, ctx:NSManagedObjectContext, id:NSManagedObjectID) in
            
            let controller = CDSColorPalette.getPalettes(
                ctx: ctx,
                ids: [id],
                sectionNameKeyPath: #keyPath(CDSColorPalette.displayCreationDate)
            )
            controller.fetchRequest.sortDescriptors = [
                .init(key:#keyPath(CDSColorPalette.creationDate), ascending:false)
                
            ]
            return controller
        }
        
        return container
    }()

}
