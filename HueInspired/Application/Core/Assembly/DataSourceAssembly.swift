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
    
    enum DataSourceConfig: String {
        case all
        case favs
    }
    
    private let internalContainer: Container = {
        let container = Container()

        // DATA SOURCES
        
        container.register(CoreDataPaletteDataSource.self) { (r:Resolver, data:NSFetchedResultsController<CDSColorPalette>)  in
            return CoreDataPaletteDataSource(data: data)
            }.inObjectScope(.transient)
        
        container.register(CoreDataPaletteDataSource.self, name:"Synced") { (r, controller:NSFetchedResultsController<CDSColorPalette>) in
            
            let data = r.resolve(CoreDataPaletteDataSource.self, argument: controller)!
            
            do {
                try data.syncData()
            }
            catch {
                print("Failed to sync core data datasource for 'all' palettes")
            }
            return data
            
            }.inObjectScope(.transient)
        
        return container
    }()
    
    
    func assemble(container: Container) {
        
        // PUBLIC DATA SOURCE
        
        container.register(UserPaletteDataSource.self, name:DataSourceConfig.all.rawValue) { (r) in
            
            let persistentData: NSPersistentContainer = r.resolve(NSPersistentContainer.self)!
            let controller = r.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Trending", argument:persistentData.viewContext)!
            return self.internalContainer.resolve(CoreDataPaletteDataSource.self, name:"Synced", argument: controller)!
        }
        
        container.register(UserPaletteDataSource.self, name:DataSourceConfig.favs.rawValue) { (r) in
            
            let persistentData: NSPersistentContainer = r.resolve(NSPersistentContainer.self)!
            let controller = r.resolve(NSFetchedResultsController<CDSColorPalette>.self, name:"Favs", argument:persistentData.viewContext)!
            return self.internalContainer.resolve(CoreDataPaletteDataSource.self, name:"Synced", argument: controller)!
        }
        
        
        // MARK: FACTORY
        
        container.register(ColorPaletteDataSourceFactory.self) { r in
            return r.resolve(ColorPaletteDataSourceFactory.self, name:"Managed")!
        }
        
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
                let dataSource = self.internalContainer.resolve(CoreDataPaletteDataSource.self, argument: controller)!
                do {
                    try dataSource.syncData()
                }
                catch {
                    return nil
                }
                return dataSource as UserPaletteDataSource
            }
        }

        container.register(ColorPaletteDataSourceFactory.self, name:"Temp") { r in
            
            let persistentData: NSPersistentContainer = r.resolve(NSPersistentContainer.self)!
            
            return { (p:ColorPalette) -> UserPaletteDataSource? in
                let dataSource = TemporaryPaletteDataSource(context: persistentData.newBackgroundContext())
                dataSource.data = p
                return dataSource as UserPaletteDataSource
            }
        }


    }
}

