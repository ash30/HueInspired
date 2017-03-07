//
//  PaletteCollectionViewModel.swift
//  HueInspired
//
//  Created by Ashley Arthur on 31/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit



// MARK: CONTROLLER

protocol PaletteCollectionDelegate {
    
    func didSelectPalette(viewController:UIViewController, index:Int)
    func didToggleFavourite(viewController:UIViewController, index:Int)
    func didSetNewPaletteName(viewController:UIViewController, name:String, index:Int)
    func didPullRefresh(tableRefresh:UIRefreshControl)
    
}

class PaletteCollectionController: PaletteCollectionDelegate, PaletteSync {
    
    var viewControllerFactory: ViewControllerFactory
    var appController: AppController
    weak var viewModel: ManagedPaletteDataSource?
    
    // cached locally to save fetching
    let favourites: CDSSelectionSet?
    
    init(appController:AppController, viewModel:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory){
        self.appController = appController
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        
        favourites = try! appController.favourites.getSelectionSet(for: appController.mainContext)
        
    }
    
    func didSelectPalette(viewController:UIViewController, index:Int){
        
        guard
            let palette = viewModel?.getElement(at: index),
            let ctx = palette.managedObjectContext,
            let favs = try? appController.favourites.getSelectionSet(for: ctx)
        else {
            return // FIXME: SHOULD PROBABLY WARN USER...
        }
        
        let data = CDSColorPalette.getPalettes(ctx: ctx, ids: [palette.objectID])
        let vc = viewControllerFactory.showPalette(
            application: appController,
            dataSource: CoreDataPaletteDataSource(data: data, favourites: favourites!)
        )
        viewController.show(vc, sender: self)
        
    }
    
    func didSetNewPaletteName(viewController:UIViewController, name:String, index:Int){
        guard
            let palette = viewModel?.getElement(at: index)
            else {
                return // FIXME: SHOULD PROBABLY WARN USER...
        }
        palette.name = name
    }
    
    func didToggleFavourite(viewController:UIViewController, index:Int){
        
        guard
            let palette = viewModel?.getElement(at: index),
            let ctx = palette.managedObjectContext,
            let favs = try? appController.favourites.getSelectionSet(for: ctx)
        else {
            return // FIXME: SHOULD PROBABLY WARN USER...
        }
        
        if !(favs.contains(palette)) {
            favs.addPalette(palette)
            try! ctx.save()
        }
        else {
            favs.removePalette(palette)
            try! ctx.save()
        }
    }
    
    func didPullRefresh(tableRefresh:UIRefreshControl){
        _ = syncLatestPalettes().then { _ in
            
            tableRefresh.endRefreshing()
            
        }.catch(execute: { (error:Error) in
            // FIXME: WE SHOULD REALLY LET THE VC KNOW 
            tableRefresh.endRefreshing()
            print("Refresh Error")
        })
    }
    
}





