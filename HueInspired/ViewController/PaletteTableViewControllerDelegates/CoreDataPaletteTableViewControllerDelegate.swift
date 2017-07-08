//
//  BasicPaletteTableViewControllerDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 08/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import PromiseKit

class CoreDataPaletteTableViewControllerDelegate: PaletteTableViewControllerDelegate {
    
    // To be used in conjuction with a core data backed data source
    // PaletteTableView is kept ignorant of backing data source, it just sees table interface
    // In the delegate we know app specific info e.g coredata etc and able to setup the next VC
    
    var factory: DetailDataSourceFactory
    
    init(factory:@escaping DetailDataSourceFactory) {
        self.factory = factory
    }
    
    func willPresentDetail(viewController:PaletteTableViewController, detail:UIViewController, index:Int ) {
        // Setup Detail VC with selected palette data
        
        guard
            let dataSource = (viewController.dataSource as? CoreDataPaletteDataSource)
        else {
            fatalError("CoreDataPaletteTableViewControllerDelegate expects Core Data backed Data Source")
        }
        
        guard
            let palette:CDSColorPalette = dataSource.getElement(at: index),
            let ctx = palette.managedObjectContext
        else {
            // TODO: Report error to VC
            return
        }
                
        if let vc = detail as? PaletteDetailViewController {
            
            let newDataSource = factory(ctx, palette.objectID)
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
