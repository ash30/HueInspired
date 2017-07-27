//
//  PaletteManagerAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 25/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import UIKit
import CoreData

class PaletteManagerAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: TABLE DELEGATES
        
        container.register(TrendingPaletteDelegate.self){ (r:Resolver) in
            let persistentData: NSPersistentContainer = r.resolve(NSPersistentContainer.self)!
            let bkgroundCtx = persistentData.newBackgroundContext()
            
            // We can possibly recreate existing palettes when syncing latest
            // This will trip validation rules on Image Source duplication
            // Existing Palettes take precedence
            bkgroundCtx.mergePolicy = NSMergePolicy.rollback
            
            return TrendingPaletteDelegate.init(
                factory:r.resolve(ColorPaletteDataSourceFactory.self)!,
                detailViewFactory:r.resolve(PaletteDetailViewFactory.self)!,
                ctx:bkgroundCtx,  // We want to new palette syncing to be done on bkground ctx
                remotePalettes: r.resolve(FlickrTrendingPhotoService.self)! as TrendingPaletteService
            )
        }
  
        
    }
}
