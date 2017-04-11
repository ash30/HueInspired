//
//  ViewControllerDelegates.swift
//  HueInspired
//
//  Created by Ashley Arthur on 07/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit
import CoreData

// shared functionality 

protocol PaletteSync: PaletteReplace {
    var remotePalettes: RemotePaletteService { get }
}

extension PaletteSync {
    
    func syncLatestPalettes(ctx:NSManagedObjectContext) -> Promise<Bool> {
        return remotePalettes.getLatest().then { (palettes: [Promise<ColorPalette>]) in
           self.replace(with: palettes, ctx: ctx)
        }
    }
}

protocol PaletteReplace {
    func replace(with palettes: [Promise<ColorPalette>], ctx:NSManagedObjectContext) -> Promise<Bool>
}
extension PaletteReplace {
    
    func replace(with palettes: [Promise<ColorPalette>], ctx:NSManagedObjectContext) -> Promise<Bool>{
        
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K.@count == 0", argumentArray: [#keyPath(CDSColorPalette.sets)])
        fetch.fetchBatchSize = 50
        
        do {
            let palettes = try ctx.fetch(fetch)
            for p in palettes {
                ctx.delete(p)
            }
        }
        catch {
            return Promise<Bool>.init(error: error)
        }
        ctx.processPendingChanges()
        
        let newCoreDataEntities = palettes.map{
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
            return true
        }
    }

}
