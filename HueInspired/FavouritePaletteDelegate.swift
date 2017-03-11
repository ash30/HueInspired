//
//  FavouritePaletteDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 07/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit



class PaletteFavouritesController: PaletteCollectionDelegate, PaletteFocus {
    
    var appController: AppController
    var viewControllerFactory: ViewControllerFactory
    weak var viewModel: ManagedPaletteDataSource? 
    
    init(appController:AppController, viewModel:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory){
        self.appController = appController
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
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
