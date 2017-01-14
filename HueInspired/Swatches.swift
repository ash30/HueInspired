//
//  swatches.swift
//  HueInspired
//
//  Created by Ashley Arthur on 14/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation




struct WeightedColor {
    var color: SimpleColor
    let count: Int
    let population: Int
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
