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

protocol PaletteSync {
    var appController: AppController { get set }
}

extension PaletteSync {
    func syncLatestPalettes() -> Promise<Bool> {
        return appController.remotePalettes.getLatest().then { (palettes: [ColorPalette]) in
            self.appController.localPalettes.replace(with: palettes)
        }
    }
}

protocol PaletteFocus: class  {
    var appController: AppController { get set }
    var viewControllerFactory: ViewControllerFactory { get set }
    weak var viewModel: ManagedPaletteDataSource? { get set }
    
}

extension PaletteFocus {
    
    func showPaletteDetail(viewController:UIViewController, index:Int){
        
        guard
            let palette = viewModel?.getElement(at: index),
            let ctx = palette.managedObjectContext,
            let favs = try? appController.favourites.getSelectionSet(for: ctx)
            else {
                return // FIXME: SHOULD PROBABLY WARN USER...
                // I think the client needs to handle the error so we need to return something?
        }
        
        let data = CDSColorPalette.getPalettes(ctx: ctx, ids: [palette.objectID])
        let vc = viewControllerFactory.showPalette(
            application: appController,
            dataSource: CoreDataPaletteDataSource(data: data, favourites: favs)
        )
        viewController.show(vc, sender: self)
//        viewController.present(vc, animated: true){
//            
//            // Notify main that they need to redo fetches
//            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "replace"), object: nil)
//            
//        }
        
    }
}
