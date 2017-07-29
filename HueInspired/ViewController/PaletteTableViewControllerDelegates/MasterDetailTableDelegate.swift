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


class MasterDetailTableDelegate: PaletteTableViewControllerDelegate {
    
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
    
}
