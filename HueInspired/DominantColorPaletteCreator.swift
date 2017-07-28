//
//  DominantColorPaletteCreator.swift
//  HueInspired
//
//  Created by Ashley Arthur on 28/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

// For now we have a single implementation of the palette creator
// which uses the built in convenience inits
// In future I think we can also optimise the image here as well.

class DominantColorPaletteCreator: PaletteCreator {
    
    func createFrom(image: UIImage, id:String) -> Promise<ColorPalette> {
        
        let p = Promise<ColorPalette>.pending()
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                let palette = ImmutablePalette(withRepresentativeSwatchesFrom: image, name: nil, guid:id)
                else {
                    p.reject(PaletteErrors.paletteCreationFailure)
                    return
            }
            p.fulfill(palette)
        }
        
        return p.promise
        
    }
    
}
