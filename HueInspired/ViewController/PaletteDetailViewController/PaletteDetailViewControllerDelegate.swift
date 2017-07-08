//
//  DetailViewDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 10/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol PaletteDetailDelegate {
    
    func didToggleFavourite(viewController:PaletteDetailViewController, palette:UserOwnedPalette) throws
    
    
}

enum PaletteDetailError: Error {
    case favouriteToggleError
}

class PaletteDetailController: PaletteDetailDelegate {
    
    var context:NSManagedObjectContext
    
    init(context:NSManagedObjectContext) {
        self.context = context
    }

    func didToggleFavourite(viewController:PaletteDetailViewController, palette:UserOwnedPalette) throws {
        
        guard let managedPalette = palette as? CDSColorPalette else {
            fatalError("Can't set non managed palette as favourite")
        }
        guard
            let ctx = managedPalette.managedObjectContext,
            let favs = try? PaletteFavourites.getSelectionSet(for: ctx)
        else{
            throw PaletteDetailError.favouriteToggleError
        }
        
        switch favs.contains(managedPalette) {
        case true:
            favs.removePalette(managedPalette)
        case false:
            favs.addPalette(managedPalette)
        }
        try ctx.save()
        
    }

    
    
}
