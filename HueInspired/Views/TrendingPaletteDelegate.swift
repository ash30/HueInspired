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

class PaletteCollectionController: PaletteCollectionDelegate, PaletteSync {
    
    var remotePalettes: RemotePaletteService
    var dataSource: CoreDataPaletteDataSource?
    var ctx: NSManagedObjectContext
    
    var collectionTitle: String? {
        return "HueInspired"
    }
    
    init(dataSource:CoreDataPaletteDataSource, ctx:NSManagedObjectContext, remotePalettes: RemotePaletteService){
        self.dataSource = dataSource
        self.ctx = ctx
        self.remotePalettes = remotePalettes
    }
    
    func didPullRefresh(tableRefresh:UIRefreshControl){
        dataSource?.syncData(waitFor:syncLatestPalettes(ctx:ctx))
    }
    
    
    
}






