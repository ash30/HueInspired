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
    var viewModel: ManagedPaletteDataSource? 
    
    init(appController:AppController, viewModel:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory){
        self.appController = appController
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
    }
    
    convenience init(appController:AppController, viewControllerFactory:ViewControllerFactory, context:NSManagedObjectContext){
        
        // FIXME: HANDLE FAIL
        // FIXME: Need to chooose context
        let favouritesSet = try! appController.favourites.getSelectionSet(for: appController.persistentData.viewContext)
        let favourites = favouritesSet.fetchMembers()!
        favourites.fetchRequest.sortDescriptors = [ .init(key:"creationDate", ascending:false)]
        let model = CoreDataPaletteDataSource(data: favourites, favourites: favouritesSet)
        
        self.init(appController:appController, viewModel:model, viewControllerFactory: viewControllerFactory)
        
    }
    
    func getDataSource() -> PaletteSpecDataSource? {
        return viewModel.flatMap{ $0 as? PaletteSpecDataSource }
    }
    
    func didSelectPalette(viewController:UIViewController, index:Int){
        // FIXME: We should hand error
        showPaletteDetail(viewController: viewController, index: index)
    }
    func didPullRefresh(tableRefresh:UIRefreshControl){
        tableRefresh.endRefreshing()
    }
    func didLoad(viewController:UIViewController){
        // Do nothing
    }
    
}
