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
    
    func didLoad(viewController:UIViewController)
    func didSelectPalette(viewController:UIViewController, index:Int)
    func didPullRefresh(tableRefresh:UIRefreshControl)
    func getDataSource() -> PaletteSpecDataSource?
    
}

class PaletteCollectionController: PaletteCollectionDelegate, PaletteSync, PaletteFocus {
    
    var viewControllerFactory: ViewControllerFactory
    var appController: AppController
    var dataSource: ManagedPaletteDataSource?
    var ctx: NSManagedObjectContext
    
    init(appController:AppController, dataSource:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory, ctx:NSManagedObjectContext){
        self.appController = appController
        self.dataSource = dataSource
        self.viewControllerFactory = viewControllerFactory
        self.ctx = ctx
    }
    
    convenience init(appController:AppController, viewControllerFactory:ViewControllerFactory, context:NSManagedObjectContext){
        
        let favouritesSet = try! PaletteFavourites.getSelectionSet(for: context)
        let trendingPalettes = CDSColorPalette.getPalettes(ctx: context)
        trendingPalettes.fetchRequest.predicate = NSPredicate(format: "%K != nil", argumentArray: [#keyPath(CDSColorPalette.source)])
        trendingPalettes.fetchRequest.sortDescriptors = [ .init(key:#keyPath(CDSColorPalette.creationDate), ascending:false)]

        let model = CoreDataPaletteDataSource(data: trendingPalettes, favourites: favouritesSet)
        
        self.init(appController:appController, dataSource:model, viewControllerFactory: viewControllerFactory, ctx:context)
        
    }
    
    func getDataSource() -> PaletteSpecDataSource? {
        return dataSource.flatMap{ $0 as? PaletteSpecDataSource }
    }
    
    func didSelectPalette(viewController:UIViewController, index:Int){
        showPaletteDetail(viewController: viewController, index: index)
    }

    func didLoad(viewController:UIViewController){
        dataSource?.syncData()
        dataSource?.syncData(event:syncLatestPalettes(ctx:ctx))
    }
    
    func didPullRefresh(tableRefresh:UIRefreshControl){
        dataSource?.syncData(event:syncLatestPalettes(ctx:ctx))
    }
}





