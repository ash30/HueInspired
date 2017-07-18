//
//  DataSourceAssemly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import CoreData

typealias ColorPaletteDataSourceFactory = (ColorPalette) -> UserPaletteDataSource?

class DataSourceAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: DATA SOURCES
        
        container.register(CoreDataPaletteDataSource.self) { (r:Resolver, data:NSFetchedResultsController<CDSColorPalette>)  in
            return CoreDataPaletteDataSource(data: data)
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
        
        // MARK: FACTORY
        
        container.register(ColorPaletteDataSourceFactory.self) { r in
            return r.resolve(ColorPaletteDataSourceFactory.self, name:"Managed")!
        }
        
        // PRIVATE
        
        container.register(ColorPaletteDataSourceFactory.self, name:"Managed") { r in
            
            return { (p:ColorPalette) -> UserPaletteDataSource? in

                // Only defined for CDSColorPalettes
                guard
                    let managedPalette = p as? CDSColorPalette,
                    let ctx = managedPalette.managedObjectContext,
                    let controller = r.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Detail", arguments:ctx, managedPalette.objectID)
                    else {
                        return nil
                }
                let dataSource = r.resolve(CoreDataPaletteDataSource.self, argument: controller)!
                do {
                    try dataSource.syncData()
                }
                catch {
                    return nil
                }
                return dataSource as UserPaletteDataSource
            }
        }
    }
}

