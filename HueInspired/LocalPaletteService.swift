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
    
    func replace(with newPalettes:[Promise<ColorPalette>], ctx:NSManagedObjectContext) -> Promise<Bool>{
        
        
        let (promise,_,reject) = Promise<Bool>.pending()

        // Because we don't delete favourite palettes, we could possibly
        // have merge conflict from duplicate image sources
        // In this case, just igore new palette, we have it already
        ctx.mergePolicy = NSMergePolicy.rollback
        
        // FIXME: DON'T HARD CODE KEY NAME
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        fetch.predicate = NSPredicate(format: "sets.@count == 0")
        fetch.fetchBatchSize = 50 // ?? WHAT NUMBER TO CHOOSE?
        do {
            let palettes = try ctx.fetch(fetch)
            for p in palettes {
                ctx.delete(p)
            }
        }
        catch {
            reject(error) // FIXME: WHAT TODO WITH THIS?
            return promise
        }
        ctx.processPendingChanges()
        
        let newCoreDataEntities = newPalettes.map{
            $0.then{ (palette:ColorPalette) -> () in
                if palette.contrast(threshold:1) > 3 {
                    _ = CDSColorPalette(context: ctx, palette: palette)
                }
                else{
                    let interestingPalette = ImmutablePalette.init(namedButWithRandomColors: palette.name)
                    let entity = CDSColorPalette(context: ctx, palette: interestingPalette)
                    // Copy over image source
                    if let id = palette.guid {
                        entity.source = CDSImageSource(context: ctx, id: id, palette: entity, imageData: nil)
                    }
                    
                }
                ctx.processPendingChanges()
            }
        }
        
        return when(fulfilled: newCoreDataEntities).then { () -> Bool in
            try ctx.save()
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "replace"), object: nil)
            return true
        }
        
        
    }
    
    
    
    

    
}

