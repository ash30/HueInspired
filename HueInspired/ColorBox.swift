//
//  ColorBox.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import Foundation
import UIKit

struct ColorBox {
    
    let colors: [SimpleColor]
    var count: Int {
        return colors.count
    }
    
    let rMax: Int, rMin: Int
    let gMax: Int, gMin: Int
    let bMax: Int, bMin: Int
    
    var volume: Int {
        return (max((rMax - rMin),1)) * (max((gMax - gMin),1)) * (max((bMax - bMin),1))
    }
    
    init(colors:[SimpleColor]){
        
        self.colors = colors
        
        let rAll = colors.map{ $0.r }
        let gAll = colors.map{ $0.g }
        let bAll = colors.map{ $0.b }
        
        rMax = rAll.max() ?? 1
        rMin = rAll.min() ?? 0
        gMax = gAll.max() ?? 1
        gMin = gAll.min() ?? 0
        bMax = bAll.max() ?? 1
        bMin = bAll.min() ?? 0
    }
    
    var averageColor: SimpleColor {
        let sum = colors.reduce(
        SimpleColor(r: 0, g: 0, b: 0, a: 1)){
            return SimpleColor(r: $0.r + $1.r, g: $0.g + $1.g, b: $0.b + $1.b, a: 1)
        }
        
        let count = Double(self.count)
        return SimpleColor(
            r: Int(Double(sum.r)/count),
            g: Int(Double(sum.g)/count),
            b: Int(Double(sum.b)/count),
            a: 1
        )
    }
}

extension ColorBox: Equatable{
    static func ==(lhs: ColorBox, rhs: ColorBox) -> Bool {
        return lhs.colors == rhs.colors
    }
}

extension ColorBox {
    
    enum Dimensions{
        case red
        case green
        case blue
    }
    
    var longestDimensionPredicate: (SimpleColor,SimpleColor)->Bool {
        
        if rMax >= gMax && rMax >= bMax {
            return {$0.r < $1.r}
        }
        else if gMax >= rMax && gMax >= bMax {
            return {$0.g < $1.g}
        }
        else {
            return {$0.b < $1.b}
        }
    }
    
    func indexOfSplit(colors:[SimpleColor]) -> Int {
        
        //we can either split on average OR make a long list of values yeah and do proper median 
        
        // Split RED
        if rMax >= gMax && rMax >= bMax {
            let middleValue = colors.map{$0.r}[Int((Float(colors.count) / 2.0).rounded())]
            if colors[0].r == middleValue{
               return colors.index(where: {$0.r > middleValue})!
            }
            else {
                return colors.index(where: {$0.r == middleValue})!
            }
        }
            
        // SPLIT GREEN
        else if gMax >= rMax && gMax >= bMax {
            let middleValue = colors.map{$0.g}[Int((Float(colors.count) / 2.0).rounded())]
            if colors[0].g == middleValue{
                return colors.index(where: {$0.g > middleValue})!
            }
            else {
                return colors.index(where: {$0.g == middleValue})!
            }
        }
            
        // SPLIT BLUE
        else {
            let middleValue = colors.map{$0.b}[Int((Float(colors.count) / 2.0).rounded())]
            if colors[0].b == middleValue{
                return colors.index(where: {$0.b > middleValue})!
            }
            else {
                return colors.index(where: {$0.b == middleValue})!
            }
        }
    }
    
    func split() -> (ColorBox,ColorBox)? {
        guard count > 1 else {
            return nil
        }
        let sortedColors = colors.sorted(by: longestDimensionPredicate)
        let splitIndex = indexOfSplit(colors:sortedColors)
        guard splitIndex > 0 else { return nil }
        
        // The problem here is the middle index in the array MAY NOT be the real median value
        // hence there likely hood of index being zero is more likely
        // We need to get the middle value of the range...
        
        let s1 = Array(sortedColors[0..<splitIndex])
        let s2 = Array(sortedColors[splitIndex..<colors.count])
        return (ColorBox(colors: s1),ColorBox(colors:s2))
        
    }
}

extension ColorBox: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Colorbox(Count:\(self.count) rMAX: \(self.rMax) rMin: \(self.rMin) gMAX: \(self.gMax) gMin: \(self.gMin) bMAX: \(self.bMax) bMin: \(self.bMin)"
    }
    
}
