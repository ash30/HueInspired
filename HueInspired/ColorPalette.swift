//
//  ColorPalette.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import Foundation
import UIKit


struct WeightedColor {
    var color: SimpleColor
    let count: Int
    let population: Int
}

struct RepresentativePalette {
    let sourceImage: UIImage?

    let vibrant: SimpleColor
    let vibrantLight: SimpleColor
    let vibrantDark: SimpleColor
    let muted: SimpleColor
    let mutedLight: SimpleColor
    let mutedDark: SimpleColor
}

extension RepresentativePalette {
    var colors: [SimpleColor] {
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

func searchColors(_ colors:[WeightedColor], chromaTarget:Float, valueTarget:Float) -> SimpleColor{
    
    let order = colors.sorted { (a:WeightedColor, b:WeightedColor) -> Bool in
        let values = [a,b].map{
            Float.abs(chromaTarget - $0.color.RGBtoHSV().1) + Float.abs(valueTarget - $0.color.RGBtoHSV().2)
        }
        return values[0] < values[1]
    }
    
    return order.first?.color ?? SimpleColor(r: 0, g: 0, b: 0)
}

extension RepresentativePalette {
    
    // Generate a list of colors from input image
    init?(sourceImage: UIImage){
        guard
            let image = sourceImage.cgImage,
            let fixedSizeInput = createFixedSizedSRGBThumb(image: image, size: 100),
            let pixelData = extractPixelData(image:fixedSizeInput)
        else {
            return nil // this didn't work
        }
        self.sourceImage = sourceImage
        let boxes: [ColorBox] = divideSpace(colors: pixelData, numberOfBoxes: 256)
        
        let weightedColors = boxes.map { WeightedColor(color: $0.averageColor, count: $0.count, population: pixelData.count)
        }.sorted { $0.count < $1.count }
        
        // TODO: Choose Better Magic numbers
        
        vibrant = searchColors(weightedColors, chromaTarget:1.0, valueTarget:1.0)
        
        vibrantLight = searchColors(weightedColors, chromaTarget:0.1, valueTarget:1.0)
        
        vibrantDark = searchColors(weightedColors, chromaTarget:1.0, valueTarget:0.1)
        
        muted = searchColors(weightedColors, chromaTarget:0.4, valueTarget:0.6)
        
        mutedLight = searchColors(weightedColors, chromaTarget:0.25, valueTarget:0.6)
        
        mutedDark = searchColors(weightedColors, chromaTarget:0.5, valueTarget:0.2)
    
    }
}
