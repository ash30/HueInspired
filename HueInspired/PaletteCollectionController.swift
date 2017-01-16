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
    
}

class PaletteCollectionController: PaletteCollectionDelegate {
    
    var viewControllerFactory: ViewControllerFactory
    var appController: AppController
    weak var viewModel: ManagedPaletteDataSource?
    
    init(appController:AppController, viewModel:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory){
        self.appController = appController
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
    }
    
    func didSelectPalette(viewController:UIViewController, index:Int){
        
        guard let palette = viewModel?.getElement(at: index) else {
            return // FIXME: SHOULD PROBABLY WARN USER...
        }
        
        let data = appController.paletteManager.getPalette(id: palette.objectID)
        let vc = viewControllerFactory.showPalette(
            application: appController,
            dataSource: CoreDataPaletteSpecDataSource(data: data)
        )
        viewController.show(vc, sender: self)
        
    }
    
    func didToggleFavourite(viewController:UIViewController, index:Int){
        
        guard let palette = viewModel?.getElement(at: index) else {
            return // FIXME: SHOULD PROBABLY WARN USER...
        }
        
        // FIXME: HANDLE ERROR PLEASE
        
        if appController.favouriteManager.isfavourite(palette) == true {
            try? appController.favouriteManager.removeFavourite(palette)
        }
        else{
            try? appController.favouriteManager.addFavourite(palette)
        }
    }
    
}





