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
    
    var factory: ColorPaletteDataSourceFactory
    let detailViewFactory: PaletteDetailViewFactory
    var delegate: PaletteTableViewControllerDelegate?
    
    init(factory:@escaping ColorPaletteDataSourceFactory, detailViewFactory:@escaping PaletteDetailViewFactory) {
        self.factory = factory
        self.detailViewFactory = detailViewFactory
    }
    
    func didPullRefresh(viewController:PaletteTableViewController){
        if let delegate = delegate {
            delegate.didPullRefresh(viewController: viewController)
        }
        else {
            // Default is do nothing and set state back to stop spinner
            viewController.currentDisplayState = .final
        }
        
    }
    
    func didSelectPalette(viewController:PaletteTableViewController, palette:UserOwnedPalette) throws {
        
        guard
            let newDataSource = factory(palette)
        else {
            throw PaletteTableViewControllerDelegateError.dataSourceCreationFail
        }
        let detailVC = detailViewFactory()
        detailVC.dataSource = newDataSource
        viewController.show(detailVC, sender: nil)
        
    }
    
    func willPresentDetail(viewController:PaletteTableViewController, detail:UserPaletteDetails, palette:UserOwnedPalette ) throws {
        // Setup Detail VC with datasource based on selected Palette
        
        guard
            let newDataSource = factory(palette)
        else {
            throw PaletteTableViewControllerDelegateError.dataSourceCreationFail
        }
        detail.dataSource = newDataSource
    }
    
}
