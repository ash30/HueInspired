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

protocol PaletteCollectionDelegate {
    
    var dataSource: ManagedPaletteDataSource? { get set }    
    func didPullRefresh(tableRefresh:UIRefreshControl)
    func willPresentDetail(viewController:UIViewController, index:Int )
    
}

extension PaletteCollectionDelegate {
    func willPresentDetail(viewController:UIViewController, index:Int ){
        guard
            let palette = dataSource?.getElement(at: index),
            let ctx = palette.managedObjectContext,
            let favs = try? PaletteFavourites.getSelectionSet(for: ctx)
            else {
                return
        }
        if let vc = viewController as? PaletteDetailViewController {
            let data = CDSColorPalette.getPalettes(ctx: ctx, ids: [palette.objectID])
            let dataSource = CoreDataPaletteDataSource(data: data, favourites: favs)
            let delegate = PaletteDetailController(dataSource: dataSource)
            vc.dataSource = dataSource
            vc.delegate = delegate
        }
    }
}

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






