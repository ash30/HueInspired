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

class TrendingPaletteDelegate: CoreDataPaletteTableViewControllerDelegate {
    
    var remotePalettes: RemotePaletteService
    var ctx: NSManagedObjectContext
    
    init(factory:@escaping DetailDataSourceFactory, ctx:NSManagedObjectContext, remotePalettes: RemotePaletteService){
        self.ctx = ctx
        self.remotePalettes = remotePalettes
        super.init(factory: factory)
    }
    
    func didPullRefresh(viewController:PaletteTableViewController){
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
        .catch { (err:Error) in
            // we should potentially reset the ctx at this point as well
            viewController.report(error: err)
        }
        .always {
            // Always stop the pending spinner
            viewController.currentDisplayState = .final
        }
        
    }
    
    
    
}






