//
//  ColorPalette.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// MARK: INTERFACE

enum PaletteSource {
    case image
    case trend
    case search
}

protocol PaletteMetaData {
    var image: UIImage { get set }
    var name: String? { get }
    var query: String? { get set }
    var type: PaletteSource? { get set }
}

protocol ColorData {
    var colors: [DiscreteRGBAColor] {get}
}

protocol ColorPalette: ColorData, PaletteMetaData {

}

// MARK: IMPLEMENTATIONS

struct RepresentativePalette {
    let vibrant: SimpleColor
    let vibrantLight: SimpleColor
    let vibrantDark: SimpleColor
    let muted: SimpleColor
    let mutedLight: SimpleColor
    let mutedDark: SimpleColor
}

extension RepresentativePalette {
    init(swatches: [Swatch]){
        vibrant = searchColors(swatches, chromaTarget:1.0, valueTarget:1.0)
        vibrantLight = searchColors(swatches, chromaTarget:0.1, valueTarget:1.0)
        vibrantDark = searchColors(swatches, chromaTarget:1.0, valueTarget:0.1)
        muted = searchColors(swatches, chromaTarget:0.4, valueTarget:0.6)
        mutedLight = searchColors(swatches, chromaTarget:0.25, valueTarget:0.6)
        mutedDark = searchColors(swatches, chromaTarget:0.5, valueTarget:0.2)
    }
}

extension RepresentativePalette: ColorData {
    var colors: [DiscreteRGBAColor] {
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

