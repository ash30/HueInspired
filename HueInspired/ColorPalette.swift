//
//  ColorPalette.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import Foundation
import simd

protocol Palette {
    var colors: [SimpleColor] { get set }
}

struct ColorPalette: Palette {
    
    var colors: [SimpleColor] = []
    let _boxes: [ColorBox]
    
    
    // Really Simple implementation... Will Probably need to improve
    // we just choose dominant color + 5 more
    
    init(colors:[SimpleColor], maxSize:Int = 256){
        
        _boxes = divideSpace(colors: colors, numberOfBoxes: maxSize)
        let originalSpace = ColorBox(colors: colors)
        
        if let c1 = (_boxes.max(by: {$0.count > $1.count})?.averageColor) {
            self.colors.append(c1)
            
            let origin = float3.init(Float(c1.r), Float(c1.g), Float(c1.b))
            
            let p = _boxes.filter{
                let c = $0.averageColor
                let v = float3.init(Float(c.r), Float(c.g), Float(c.b))
                
                let relative_distance = Float(originalSpace.volume) / 0.2
                return distance(origin, v) > relative_distance
            }
            let sortp = p.sorted(by: { $0.count < $1.count } )
            
            for i in sortp[0...min(5,sortp.count)] {
                self.colors.append(i.averageColor)
            }
        }
        
        
        
    }
}
