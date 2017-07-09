//
//  FlickrTrendingPhotoService+TrendingPaletteService.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit

extension FlickrTrendingPhotoService: TrendingPaletteService {
    
    func nextPalette() -> Promise<ColorPalette> {
        
        return next().then { (photo:FlickrPhoto) -> ColorPalette in
            
            let palette = ImmutablePalette.init(
                withRepresentativeSwatchesFrom: photo.image, name: photo.description.title, guid:photo.description.id
            )
            if let palette = palette {
                return palette
            }
            else{
                // Failed to create palette, just generate a random palette instead ...
                return ImmutablePalette.init(namedButWithRandomColors: photo.description.title)
            }
        }
    }

    
}
