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
        
        return next().then { (photo:FlickrPhoto) -> Promise<ColorPalette> in
            
            let p = Promise<ColorPalette>.pending()
            
            // kick this off on the background to avoid hanging the UI
            DispatchQueue.global(qos: .userInitiated).async {
                let palette = ImmutablePalette.init(
                    withRepresentativeSwatchesFrom: photo.image, name: photo.description.title, guid:photo.description.id
                )
                if let palette = palette {
                    p.fulfill(palette)
                }
                else{
                    // Failed to create palette, just generate a random palette instead ...
                    p.fulfill(ImmutablePalette.init(namedButWithRandomColors: photo.description.title))
                    
                }
            }
            return p.promise

        }
    }

    
}
