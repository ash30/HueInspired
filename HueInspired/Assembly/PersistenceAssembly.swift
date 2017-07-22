//
//  PersistenceAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import CoreData

class PersistenceAssembly: Assembly {
    
    func assemble(container: Container) {

        // MARK: PERSISTENT CONTAINER

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
        
        
        // MARK: PREFERENCES
        
        container.register(PreferenceRegistry.self) { _ in
            UserDefaults.standard
        }
        
        // MARK: FETCH RESULTS CONTROLLER
        
        container.register(NSFetchedResultsController<CDSColorPalette>.self, name:"Favs"){ (r:Resolver, ctx:NSManagedObjectContext) in
            
            let controller = (try! PaletteFavourites.getSelectionSet(for: ctx)).fetchMembers()!
            controller.fetchRequest.sortDescriptors = [ .init(key:#keyPath(CDSColorPalette.creationDate), ascending:false)]
            return controller
        }
        
        container.register(NSFetchedResultsController<CDSColorPalette>.self, name:"Trending"){ (r:Resolver, ctx:NSManagedObjectContext) in
            
            let controller = CDSColorPalette.getPalettes(ctx: ctx, sectionNameKeyPath: #keyPath(CDSColorPalette.displayCreationDate))
            //            controller.fetchRequest.predicate = NSPredicate(
            //                format: "%K != nil", argumentArray: [#keyPath(CDSColorPalette.source)]
            //            )
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

        
        
     }
}
