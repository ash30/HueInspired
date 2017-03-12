//
//  SwatchCollections.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//
import Foundation
import UIKit

// Really these are different strategies for creating a subset of swatches
// From an image. They should all provide an iterable interface over a collection of colors

struct RepresentativeSwatchCollection {
    
    let vibrant: SimpleColor
    let vibrantLight: SimpleColor
    let vibrantDark: SimpleColor
    let muted: SimpleColor
    let mutedLight: SimpleColor
    let mutedDark: SimpleColor
    
}

extension RepresentativeSwatchCollection {
    
    init(swatches: [Swatch]){
        vibrant = searchColors(swatches, chromaTarget:1.0, valueTarget:1.0)
        vibrantLight = searchColors(swatches, chromaTarget:0.1, valueTarget:1.0)
        vibrantDark = searchColors(swatches, chromaTarget:1.0, valueTarget:0.15)
        muted = searchColors(swatches, chromaTarget:0.4, valueTarget:0.6)
        mutedLight = searchColors(swatches, chromaTarget:0.25, valueTarget:0.6)
        mutedDark = searchColors(swatches, chromaTarget:0.5, valueTarget:0.2)
    }
    
    var colorData: [DiscreteRGBAColor] {
        return [
            vibrant,
            vibrantLight,
            vibrantDark,
            muted,
            mutedLight,
            mutedDark
        ]
    }
}
