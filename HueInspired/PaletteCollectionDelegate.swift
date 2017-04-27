//
//  ViewControllerDelegates.swift
//  HueInspired
//
//  Created by Ashley Arthur on 07/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// General Protocol for a Palette + collection view based VC

protocol PaletteCollectionDelegate {
    
    var dataSource: ManagedPaletteDataSource? { get set }
    var collectionTitle: String? { get }
    
    func didPullRefresh(tableRefresh:UIRefreshControl)
    func willPresentDetail(viewController:UIViewController, index:Int )
    
}

extension PaletteCollectionDelegate {
    
    var collectionTitle:String? {
        return nil
    }
    
    func willPresentDetail(viewController:UIViewController, index:Int ){
        guard
            let palette = dataSource?.getElement(at: index),
            let ctx = palette.managedObjectContext
            else {
                return
        }
        if let vc = viewController as? PaletteDetailViewController {
            let data = CDSColorPalette.getPalettes(ctx: ctx, ids: [palette.objectID])
            let dataSource = CoreDataPaletteDataSource(data: data)
            let delegate = PaletteDetailController(dataSource: dataSource)
            vc.dataSource = dataSource
            vc.delegate = delegate
            dataSource.syncData()
        }
    }
}
