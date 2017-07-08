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
import PromiseKit

protocol PaletteTableViewControllerDelegate {
    
    func didPullRefresh(viewController:PaletteTableViewController)
    func willPresentDetail(viewController:PaletteTableViewController, detail:UIViewController, index:Int )
    
}

extension PaletteTableViewControllerDelegate {
    
    func didPullRefresh(viewController:PaletteTableViewController){
        
        // Default is do nothing and set state back to stop spinner
        viewController.currentDisplayState = .final
    
    }
    
    func willPresentDetail(viewController:PaletteTableViewController, detail:UIViewController, index:Int ){
        
        // PaletteTableView is kept ignorant of backing data source, it just sees table interface
        // In the delegate we know app specific info e.g coredata etc and can setup the next VC
        
        guard
            let dataSource = (viewController.dataSource as? CoreDataPaletteDataSource),
            let palette:CDSColorPalette = dataSource.getElement(at: index),
            let ctx = palette.managedObjectContext
        else {
            return
        }
        
        // TODO: Move this out of protocol
        
        if let vc = detail as? PaletteDetailViewController {
            let coreDataController = CDSColorPalette.getPalettes(ctx: ctx, ids: [palette.objectID])
            let newDataSource = CoreDataPaletteDataSource(data: coreDataController)
            vc.dataSource = Promise(value: newDataSource)

            let delegate = UserManagedPaletteDetailDelegate(context: ctx)
            vc.delegate = delegate

            do {
                try newDataSource.syncData()
            }
            catch {
                vc.report(error: error)
            }
        }
    }
}
