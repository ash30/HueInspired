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
    func didToggleFavourite(viewController:UIViewController, index:Int) throws 
    func didSetNewPaletteName(viewController:UIViewController, name:String, index:Int)
    
}

enum PaletteDetailError: Error {
    case favouriteToggleError
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
    
    func didToggleFavourite(viewController:UIViewController, index:Int) throws{
        
        guard
            let palette = viewModel?.getElement(at: index),
            let ctx = palette.managedObjectContext,
            let favs = try? PaletteFavourites.getSelectionSet(for: ctx)
            else {
                throw PaletteDetailError.favouriteToggleError
        }
        
        switch favs.contains(palette) {
            case true:
            favs.removePalette(palette)
            case false:
            favs.addPalette(palette)
        }
        try ctx.save()
        // Make main ctx fetch result controllers refresh incase detail view is off main ctx
        // FIXME: REALLY NEED TO FORMALISE THIS
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "replace"), object: nil)

    }
    
    func didSetNewPaletteName(viewController:UIViewController, name:String, index:Int) {
        guard
            let palette = viewModel?.getElement(at: index)
            else {
                return 
        }
        palette.name = name
    }
    
    
}
