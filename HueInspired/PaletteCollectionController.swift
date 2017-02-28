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
    
    // cached locally to save fetching
    let favourites: CDSSelectionSet?
    
    init(appController:AppController, viewModel:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory){
        self.appController = appController
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        
        favourites = try? appController.getFavourites(for: appController.persistentContainer.viewContext)
        
    }
    
    func didSelectPalette(viewController:UIViewController, index:Int){
        
        guard let palette = viewModel?.getElement(at: index) else {
            return // FIXME: SHOULD PROBABLY WARN USER...
        }
        
        let data = appController.getPalette(id: palette.objectID)
        let vc = viewControllerFactory.showPalette(
            application: appController,
            dataSource: CoreDataPaletteSpecDataSource(data: data)
        )
        viewController.show(vc, sender: self)
        
    }
    
    func didToggleFavourite(viewController:UIViewController, index:Int){
        
        guard
            let palette = viewModel?.getElement(at: index),
            let favourites = favourites
        else {
            return // FIXME: SHOULD PROBABLY WARN USER...
        }
                
        if favourites.contains(palette) {
            favourites.addPalette(palette)
        }
        else {
            favourites.removePalette(palette)
        }
    }
    
}





