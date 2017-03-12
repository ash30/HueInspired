//
//  Color.swift
//  HueInspired
//
//  Created by Ashley Arthur on 14/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// MARK: INTERFACE

protocol DiscreteRGBAColor {
    var r: Int { get }
    var g: Int { get }
    var b: Int { get }
    var a: Int { get }
}

extension DiscreteRGBAColor {
    var uiColor: UIColor {
        return UIColor(
            colorLiteralRed: Float(r) / 255.0,
            green: Float(g) / 255.0,
            blue: Float(b) / 255.0,
            alpha: 1.0
        )
    }
    
    func distance(_ a:DiscreteRGBAColor, _ b: DiscreteRGBAColor) -> Double {
        let sum = [
            b.r - a.r,
            b.g - a.g,
            b.b - a.b
        ].map {pow(Float($0), 2.0 )}.reduce(0){ $0 + $1 }
        return sqrt(Double(sum))
    }
    
}

// MARK: IMPLEMENTATIONS

struct SimpleColor: DiscreteRGBAColor {
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

    
    func RGBtoHSV() -> (Float,Float,Float) {
        
        // https://en.wikipedia.org/wiki/HSL_and_HSV#Hue_and_chroma
        // http://coecsl.ece.illinois.edu/ge423/spring05/group8/FinalProject/HSV_writeup.pdf
        
        let r = Float(self.r) / 256.0, g = Float(self.g) / 256.0, b = Float(self.b) / 256.0
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
