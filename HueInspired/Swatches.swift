//
//  swatches.swift
//  HueInspired
//
//  Created by Ashley Arthur on 14/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


struct Swatch {
    var color: SimpleColor
    let count: Int
    let population: Int
}

func swatchesFromImage(sourceImage: UIImage) -> [Swatch]?{
    guard
        let image = sourceImage.cgImage,
        let fixedSizeInput = createFixedSizedSRGBThumb(image: image, size: 100),
        let pixelData = extractPixelData(image:fixedSizeInput)
        else {
            return nil // this didn't work
    }
    let boxes: [ColorBox] = divideSpace(colors: pixelData, numberOfBoxes: 256)
    
    return boxes.map { Swatch(color: $0.averageColor, count: $0.count, population: pixelData.count)
        }.sorted { $0.count < $1.count }
}


func searchColors(_ colors:[Swatch], chromaTarget:Float, valueTarget:Float) -> SimpleColor{
    
    let order = colors.sorted { (a:Swatch, b:Swatch) -> Bool in
        let values = [a,b].map{
            Float.abs(chromaTarget - $0.color.RGBtoHSV().1) + Float.abs(valueTarget - $0.color.RGBtoHSV().2)
        }
        return values[0] < values[1]
    }
    
    return order.first?.color ?? SimpleColor(r: 0, g: 0, b: 0)
}
