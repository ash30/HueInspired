//
//  PaletteSpecDataSource_CoreData.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData


class CoreDataPaletteSpecDataSource: CoreDataPaletteDataSource, PaletteSpecDataSource {
    
    var favouritesManager: FavouritesManager?
    
    func getElement(at index: Int) -> PaletteSpec? {
        guard
            let palette: CDSColorPalette = getElement(at: index)
            else {
                return nil
        }
        
        // FIXME: Need to reconnect favourites
        let isFav = false
        
        // FIXME: Convert to convenience init
        return PaletteSpec(name: palette.name, colorData: palette.colorData, image: palette.image, isFavourite: isFav)    }

}


