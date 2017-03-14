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
import CoreData



// MARK: CONTROLLER


protocol PaletteCollectionDelegate {
    
    func didLoad(viewController:UIViewController)
    func didSelectPalette(viewController:UIViewController, index:Int)
    func didPullRefresh(tableRefresh:UIRefreshControl)
    
    func getDataSource() -> PaletteSpecDataSource?
}

class PaletteCollectionController: PaletteCollectionDelegate, PaletteSync {
    
    var viewControllerFactory: ViewControllerFactory
    var appController: AppController
    var viewModel: ManagedPaletteDataSource?
    var ctx: NSManagedObjectContext
    
    init(appController:AppController, viewModel:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory, ctx:NSManagedObjectContext){
        self.appController = appController
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        self.ctx = ctx
    }
    
    convenience init(appController:AppController, viewControllerFactory:ViewControllerFactory, context:NSManagedObjectContext){
        
        // FIXME: HANDLE FAIL
        let ctx = appController.persistentData.newBackgroundContext()
        
        let favouritesSet = try! appController.favourites.getSelectionSet(for: ctx)
        let trendingPalettes = CDSColorPalette.getPalettes(ctx: ctx)
        trendingPalettes.fetchRequest.predicate = NSPredicate(format: "source != nil", argumentArray: nil)
        
        let model = CoreDataPaletteDataSource(data: trendingPalettes, favourites: favouritesSet)
        
        self.init(appController:appController, viewModel:model, viewControllerFactory: viewControllerFactory, ctx:ctx)
        
    }
    
    func getDataSource() -> PaletteSpecDataSource? {
        return viewModel.flatMap{ $0 as? PaletteSpecDataSource }
    }
    
    func didSelectPalette(viewController:UIViewController, index:Int){
        
        // we get the palette and its parent ctx 
        // we get selection set from that ctx
        // we then create a palette fetch contoller from that ctx
        // we then show its
        
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
            dataSource: CoreDataPaletteDataSource(data: data, favourites: favs)
        )
        viewController.show(vc, sender: self)
    }

    func didLoad(viewController:UIViewController){
        viewModel?.syncData()
        viewModel?.syncData(event:syncLatestPalettes(ctx:ctx))
    }
    
    func didPullRefresh(tableRefresh:UIRefreshControl){
        viewModel?.syncData(event:syncLatestPalettes(ctx:ctx))
    }
}





