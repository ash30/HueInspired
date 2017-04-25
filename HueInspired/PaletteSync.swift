//
//  PaletteSync.swift
//  HueInspired
//
//  Created by Ashley Arthur on 25/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import CoreData

// MARK: PALETTE SYNC TRAIT

protocol PaletteSync {
    var remotePalettes: RemotePaletteService { get }
}

extension PaletteSync {
    
    func syncLatestPalettes(ctx:NSManagedObjectContext) -> Promise<Bool> {
        return remotePalettes.getLatest().then { (palettes: [Promise<ColorPalette>]) in
            self.replace(with: palettes, ctx: ctx)
        }
    }
    
    func replace(with palettes: [Promise<ColorPalette>], ctx:NSManagedObjectContext) -> Promise<Bool>{
        
        let newCoreDataEntities = palettes.map{
            $0.then{ (palette:ColorPalette) -> () in
                _ = CDSColorPalette(context: ctx, palette: palette)
            }
        }
        return when(fulfilled: newCoreDataEntities).then { () -> Bool in
            try ctx.save()
            return true
        }
    }
    
}

class PaletteSyncer {
    
    let dataService: RemotePaletteService
    let ctx: NSManagedObjectContext
    let workQueue = DispatchQueue.init(label: "paletteSyncer")

    
    init(dataService: RemotePaletteService, ctx:NSManagedObjectContext){
        self.dataService = dataService
        self.ctx = ctx
    }
    
    func syncLatest() -> Promise<Bool> {
        
        return dataService.getLatest().then { (palettes: [Promise<ColorPalette>]) in
            
            let newCoreDataEntities = palettes.map{
                $0.then{ (palette:ColorPalette) -> () in
                    _ = CDSColorPalette(context: self.ctx, palette: palette)
                }
            }
            return when(fulfilled: newCoreDataEntities).then { () -> Bool in
                try self.ctx.save()
                return true
            }
        }
    }
    
}
