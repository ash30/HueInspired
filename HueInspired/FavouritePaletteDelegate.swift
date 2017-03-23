//
//  FavouritePaletteDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 07/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class PaletteFavouritesController: PaletteCollectionDelegate, PaletteFocus {
    
    var appController: AppController
    var viewControllerFactory: ViewControllerFactory
    var dataSource: ManagedPaletteDataSource? 
    
    init(appController:AppController, dataSource:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory){
        self.appController = appController
        self.dataSource = dataSource
        self.viewControllerFactory = viewControllerFactory
    }
    
    convenience init(appController:AppController, viewControllerFactory:ViewControllerFactory, context:NSManagedObjectContext){
        
        // FIXME: HANDLE FAIL
        let favouritesSet = try! PaletteFavourites.getSelectionSet(for: context)
        let favourites = favouritesSet.fetchMembers()!
        favourites.fetchRequest.sortDescriptors = [ .init(key:#keyPath(CDSColorPalette.creationDate), ascending:false)]
        let model = CoreDataPaletteDataSource(data: favourites, favourites: favouritesSet)
        
        self.init(appController:appController, dataSource:model, viewControllerFactory: viewControllerFactory)
        
    }
    
    func getDataSource() -> PaletteSpecDataSource? {
        return dataSource.flatMap{ $0 as? PaletteSpecDataSource }
    }
    
    func didSelectPalette(viewController:UIViewController, index:Int){
        showPaletteDetail(viewController: viewController, index: index)
    }
    func didPullRefresh(tableRefresh:UIRefreshControl){
        tableRefresh.endRefreshing()
    }
    func didLoad(viewController:UIViewController){
        // Do nothing
    }
    
}
