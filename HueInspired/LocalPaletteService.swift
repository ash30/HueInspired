//
//  PalettteManager.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit


protocol LocalPaletteManager {
    
    var persistentData: NSPersistentContainer { get }
    
    func getPalettes() -> NSFetchedResultsController<CDSColorPalette>
    func getPalette(id: NSManagedObjectID) ->  NSFetchedResultsController<CDSColorPalette>
    func replace(with newPalettes:[ColorPalette]) -> Promise<Bool>
    
}

extension LocalPaletteManager {
    
    func getPalettes() -> NSFetchedResultsController<CDSColorPalette> {
        
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: persistentData.viewContext,
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
            managedObjectContext: persistentData.viewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        return controller
        
    }

    func replace(with newPalettes:[ColorPalette]) -> Promise<Bool> {
        
        let (promise,fulfil,reject) = Promise<Bool>.pending()
        
        persistentData.performBackgroundTask{ (context:NSManagedObjectContext) in
        
            // First delete old palettes 
            let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
            fetch.fetchBatchSize = 50 // ?? WHAT NUMBER TO CHOOSE?
            //fetch.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
            
            // FIXME: DON'T HARD CODE KEY NAME
            fetch.predicate = NSPredicate(format: "sets.@count == 0")
            do {
                let palettes = try context.fetch(fetch)
                for p in palettes {
                    context.delete(p)
                }
            }
            catch {
                // WHY Would THIS ERROR?
                reject(error) // FIXME: WHAT TODO WITH THIS?
            }

            // CREATE NEW PALETTES
            let newCoreDataEntities = newPalettes.map{
                CDSColorPalette(context: context, palette: $0)
            }
            
            do {
                try context.save()
                NotificationCenter.default.post(name: Notification.Name.init(rawValue: "replace"), object: nil)
                fulfil(newCoreDataEntities.count > 0)
                
                // Force the view layer to see new objects
            }
            catch {
                let e = error
                reject(e)
            }
        }
        
        return promise
        
        
    }
    
}

