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

protocol PaletteTableViewControllerDelegate {
    
    var dataSource: CoreDataPaletteDataSource? { get set }
    
    func didPullRefresh(tableRefresh:UIRefreshControl)
    func willPresentDetail(viewController:UIViewController, index:Int )
    
}

extension PaletteTableViewControllerDelegate {
    
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
            
            // You need to setup the view controller and if things go wrong in
            // sync, you need to set presented view to show error (phase 2)
            do {
                try dataSource.syncData()
            }
            catch {
                vc.report(error: error)
            }
        }
    }
}
