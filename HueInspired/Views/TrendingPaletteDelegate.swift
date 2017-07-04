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


// MARK: CONTROLLER

class PaletteCollectionController: PaletteTableViewControllerDelegate {
    
    var remotePalettes: RemotePaletteService
    var dataSource: CoreDataPaletteDataSource?
    var ctx: NSManagedObjectContext
    
    init(dataSource:CoreDataPaletteDataSource, ctx:NSManagedObjectContext, remotePalettes: RemotePaletteService){
        self.dataSource = dataSource
        self.ctx = ctx
        self.remotePalettes = remotePalettes
    }
    
    func didPullRefresh(tableRefresh:UIRefreshControl){
    // Sync new data on pull and update data context so it notifies data source
        
        _ = remotePalettes.getLatest().then { (palettes: [Promise<ColorPalette>]) in
            
            when(fulfilled: palettes.map {
                $0.then{
                    _ = CDSColorPalette(context: self.ctx, palette: $0)
                }
            })
            .then { _ -> () in
                try self.ctx.save()
            }
        }
        
        // FIXME: Need to handle the error 
    }
    
    
    
}






