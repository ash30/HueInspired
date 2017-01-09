//
//  SimpleColor.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import Foundation
import UIKit

struct SimpleColor {
    let r: Int
    let g: Int
    let b: Int
    let a: Int
    
    init(r:Int, g:Int, b: Int, a:Int = 1){
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

extension SimpleColor: Equatable, Hashable{
    static func ==(lhs: SimpleColor, rhs: SimpleColor) -> Bool {
        return  lhs.r == rhs.r &&
            lhs.g == rhs.g &&
            lhs.b == rhs.b
    }
    
    var hashValue: Int {
        return r ^ g ^ b
    }
}

extension SimpleColor {
    var uiColor: UIColor {

        return UIColor(
            colorLiteralRed: Float(r) / 255.0,
            green: Float(g) / 255.0,
            blue: Float(b) / 255.0,
            alpha: 1.0
        )
        
    }
    
    func RGBtoHSV() -> (Float,Float,Float) {
        
        // https://en.wikipedia.org/wiki/HSL_and_HSV#Hue_and_chroma
        // http://coecsl.ece.illinois.edu/ge423/spring05/group8/FinalProject/HSV_writeup.pdf
        
        var r = Float(self.r) / 256.0, g = Float(self.g) / 256.0, b = Float(self.b) / 256.0
        var hue:Float, saturation:Float, value:Float
        
        let MAX = max(r,g,b)
        let MIN = min(r,g,b)
        let delta = MAX - MIN
        
        value = delta
        if MAX != 0.0 {
            saturation = delta / MAX
        }
        else {
            saturation = 0.0
            hue = 0.0
            return (hue,saturation,value)
        }
        if r == MAX {
            hue = g - b
        }
        else if g == MAX {
            hue = 2 + ( b - r )
        }
        else {
            hue =  4 + ( r - g )
        }
        hue *= 60
        if hue < 0 {
            hue += 360
        }
        return (hue,saturation,value)
    }
    
}
