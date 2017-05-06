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
    var guid: String? { get }
    
}

extension ColorPalette {
    var guid:String? {
        return nil
    }
}

protocol UserOwnedPalette: ColorPalette {
    var isFavourite: Bool { get }
}

// MARK: IMMUTABLE PALETTE 

// A simple value type implementation that we can use inter changably with CDSPalette

struct ImmutablePalette: ColorPalette {
    
    let name: String?
    let colorData: [DiscreteRGBAColor]
    let image: UIImage?
    let guid: String?
    
}

extension ImmutablePalette: UserOwnedPalette {
    
    // Can Never! be favourited as its not a managed entity
    
    var isFavourite: Bool {
        return false
    }
}

extension ImmutablePalette {
    
    // Custom init utilisng Color Extraction Module
    
    init?(withRepresentativeSwatchesFrom image: UIImage, name: String?, guid:String? = nil){
        guard
            let samples  = SampleImage(sourceImage: image)
        else {
            return nil
        }
        
        let swatches = samples.flatMap { (color:FnColor) -> SimpleColor? in
            
            let outOfBounds = [color.srgb.x, color.srgb.y, color.srgb.z].filter { $0.isNaN || $0.isInfinite }
            guard outOfBounds.count == 0 else {
                return nil
            }
            return SimpleColor(r: Int(color.srgb.x * 255), g: Int(color.srgb.y * 255), b: Int(color.srgb.z * 255))
        }
                
        colorData = Array(swatches[0...min(6,swatches.count-1)])
        self.name = name
        self.image = image
        self.guid = guid
    }
    
    init(namedButWithRandomColors name:String?){
        let colors: [SimpleColor] = (0...5).map{_ in
            let values: [Int] = (0...2).map{_ in Int(arc4random() % 256)}
            return SimpleColor(r: values[0], g: values[1], b: values[2])
        }
        self.init(name:name, colorData: colors, image: nil, guid:nil)
    }
}


