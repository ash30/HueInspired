//
//  PaletteCollectionDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 31/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit
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

// MARK: CONTROLLER

class PaletteCollectionController: PaletteCollectionDelegate, PaletteSync {
    
    var remotePalettes: RemotePaletteService
    var dataSource: ManagedPaletteDataSource?
    var ctx: NSManagedObjectContext
    
    init(dataSource:ManagedPaletteDataSource, ctx:NSManagedObjectContext, remotePalettes: RemotePaletteService){
        self.dataSource = dataSource
        self.ctx = ctx
        self.remotePalettes = remotePalettes
    }
    
    func didPullRefresh(tableRefresh:UIRefreshControl){
        dataSource?.syncData(event:syncLatestPalettes(ctx:ctx))
    }
    
}






