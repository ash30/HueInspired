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
        
            // Because we don't delete favourite palettes, we could possibly
            // have merge conflict from duplicate image sources
            // In this case, just igore new palette, we have it already
            context.mergePolicy = NSMergePolicy.rollback
            
            // First delete old palettes 
            let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
            fetch.fetchBatchSize = 50 // ?? WHAT NUMBER TO CHOOSE?
            
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
                
                // Bit of a hack, if the palette is boring, we swap
                // it out for a randomly generate one
                // really we should try and fix this at the palette gen level
                if $0.contrast(threshold:1) > 3 {
                    CDSColorPalette(context: context, palette: $0)
                }
                else{
                    let interestingPalette = ImmutablePalette.init(namedButWithRandomColors: $0.name)
                    let entity = CDSColorPalette(context: context, palette: interestingPalette)
                    // Copy over image source
                    if let id = $0.guid {
                        entity.source = CDSImageSource(context: context, id: id, palette: entity, imageData: nil)
                    }

                }
                
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

