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

