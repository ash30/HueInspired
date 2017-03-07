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


class LocalPaletteManager {
    
    var persistentData: NSPersistentContainer

    init(dataLayer:NSPersistentContainer){
        persistentData = dataLayer
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

