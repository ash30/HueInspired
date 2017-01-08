//
//  ColorPalette.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import Foundation
import UIKit


struct ColorPalette {
    let colors: [SimpleColor]
    let sourceImage: UIImage?
}

extension ColorPalette {
    
    // Generate a list of colors from input image
    init?(sourceImage: UIImage){
        guard
            let image = sourceImage.cgImage,
            let fixedSizeInput = createFixedSizedSRGBThumb(image: image, size: 100),
            let pixelData = extractPixelData(image:fixedSizeInput)
        else {
            return nil // this didn't work
        }
        let boxes: [ColorBox] = divideSpace(colors: pixelData, numberOfBoxes: 256)
        colors =  boxes.sorted(by: {$0.count < $1.count})[0...min(6,boxes.count)].map{$0.averageColor}
        self.sourceImage = sourceImage
    }
    
}
