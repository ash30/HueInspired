//
//  DetailViewDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 10/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

protocol PaletteDetailDelegate {
    
    func didLoad(viewController:UIViewController)
    func didToggleFavourite(viewController:UIViewController, index:Int)
    func didSetNewPaletteName(viewController:UIViewController, name:String, index:Int)
    
}


class PaletteDetailController: PaletteDetailDelegate {
    
    var appController: AppController
    var viewControllerFactory: ViewControllerFactory
    var viewModel: ManagedPaletteDataSource?
    
    init(appController:AppController, viewModel:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory){
        
        self.appController = appController
        self.viewControllerFactory = viewControllerFactory
        self.viewModel = viewModel

    }
    
    func didLoad(viewController:UIViewController){
        viewModel?.syncData()
    }
    
    func didToggleFavourite(viewController:UIViewController, index:Int){
        
        guard
            let palette = viewModel?.getElement(at: index),
            let ctx = palette.managedObjectContext,
            let favs = try? appController.favourites.getSelectionSet(for: ctx)
            else {
                return // FIXME: SHOULD PROBABLY WARN USER...
        }
        
        switch favs.contains(palette) {
            case true:
            favs.removePalette(palette)
            case false:
            favs.addPalette(palette)
        }
        // FIXME: SHOULD PROBABLY WARN USER...
        try! ctx.save()

        
    }
    
    func didSetNewPaletteName(viewController:UIViewController, name:String, index:Int) {
        guard
            let palette = viewModel?.getElement(at: index)
            else {
                return // FIXME: SHOULD PROBABLY WARN USER...
        }
        palette.name = name
    }
    
    
}
