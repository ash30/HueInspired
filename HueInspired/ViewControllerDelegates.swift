//
//  ViewControllerDelegates.swift
//  HueInspired
//
//  Created by Ashley Arthur on 07/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit
import CoreData

// shared functionality 

protocol PaletteSync {
    var appController: AppController { get set }
}

extension PaletteSync {
    func syncLatestPalettes(ctx:NSManagedObjectContext) -> Promise<Bool> {
        return appController.remotePalettes.getLatest().then { (palettes: [Promise<ColorPalette>]) in
            self.appController.localPalettes.replace(with: palettes, ctx:ctx)
        }
    }
}

protocol PaletteFocus: class  {
    var appController: AppController { get set }
    var viewControllerFactory: ViewControllerFactory { get set }
    weak var dataSource: ManagedPaletteDataSource? { get set }
    
}

extension PaletteFocus {
    
    func showPaletteDetail(viewController:UIViewController, index:Int){
        
        guard
            let palette = dataSource?.getElement(at: index),
            let ctx = palette.managedObjectContext,
            let favs = try? PaletteFavourites.getSelectionSet(for: ctx)
            else {
                return 
        }
        
        let data = CDSColorPalette.getPalettes(ctx: ctx, ids: [palette.objectID])
        let vc = viewControllerFactory.showPalette(
            application: appController,
            dataSource: CoreDataPaletteDataSource(data: data, favourites: favs)
        )
        viewController.show(vc, sender: self)

    }

    
}
