//
//  PaletteCreator.swift
//  HueInspired
//
//  Created by Ashley Arthur on 14/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class PaletteCreator {
    
    // WIP FOR NOW
    
    func createPalette(from image:UIImage) -> ColorPalette {
        let swatches = swatchesFromImage(sourceImage: image)
        let p = RepresentativePalette(swatches: swatches!)
        return p
    }
    
    
    
}
