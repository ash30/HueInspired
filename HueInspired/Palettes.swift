//
//  Palettes.swift
//  HueInspired
//
//  Created by Ashley Arthur on 31/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// MARK: INTERFACE

// An interface so we can decouple the view layer from our NSManaged objects

protocol ColorPalette  {
    
    var name: String? { get }
    var image: UIImage? { get }
    var colorData: [DiscreteRGBAColor] { get }
    
}

protocol ColorPaletteSpec: ColorPalette {
    var isFavourite: Bool { get }
}

// MARK: IMMUTABLE PALETTE 

// A simple value type that we can use inter changably with CDSPalette

struct ImmutablePalette: ColorPalette {
    
    let name: String?
    let colorData: [DiscreteRGBAColor]
    let image: UIImage?
    
}

extension ImmutablePalette {
    
    // Custom init utilisng Color Extraction Module
    
    init?(withRepresentativeSwatchesFrom image: UIImage, name: String?){
        guard let swatches = swatchesFromImage(sourceImage: image) else {
            return nil
        }
        colorData = RepresentativeSwatchCollection(swatches: swatches).colorData
        self.name = name
        self.image = image
    }
}

// MARK: PALETTE SPEC

// This equates to full description of a palette + any meta data associated with it

struct PaletteSpec: ColorPalette, ColorPaletteSpec {
    
    let name: String?
    let colorData: [DiscreteRGBAColor]
    let image: UIImage?
    
    // I think thats all meta variables for now
    let isFavourite: Bool
    
}

