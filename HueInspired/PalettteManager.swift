//
//  PalettteManager.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData


class PaletteManager {
    
    internal let mainContext: NSManagedObjectContext

    init(context:NSManagedObjectContext){
        mainContext = context
    }
    
}

extension PaletteManager {
    
    func getPalettes() -> NSFetchedResultsController<CDSColorPalette> {
        
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: mainContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        return controller
    }
    
    func getPalette(id: NSManagedObjectID) ->  NSFetchedResultsController<CDSColorPalette> {
        // Return a results controller for single palette
        // This may be pants for performance but for now? its an easy way
        // to keep data source reactive 
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        fetch.fetchBatchSize = 1
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        fetch.predicate = NSPredicate(format: "self == %@", id)
        fetch.returnsObjectsAsFaults = false
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: mainContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        return controller
        
    }
    
}
