//
//  ColorExtractor.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import Foundation
import CoreGraphics

// Given a list of input pixel data, attempt to generate a list of color boxes

func divideSpace(colors:[SimpleColor], numberOfBoxes:Int) -> [ColorBox]{
    
    let initialBox = ColorBox(colors: colors)
    if initialBox.count < 2 {
        return [initialBox]
    }
    var boxes = [initialBox]
    for i in 0..<numberOfBoxes {
        
        let BoxesSortedByLargestAndDividable = boxes.filter{ $0.volume > 4 }
            .sorted{ $0.count > $1.count }

        var newBoxes: (ColorBox,ColorBox)? = nil
        for box in BoxesSortedByLargestAndDividable {
            //print("begin")

            newBoxes = box.split()
            if let newBoxes = newBoxes {
                boxes = boxes.filter{ $0 != box }
                boxes.append(newBoxes.0)
                boxes.append(newBoxes.1)
                break
            }
        }
        guard
            newBoxes != nil
        else {
            return boxes // the largest box only had 1 element
        }
    }
    return boxes
}










