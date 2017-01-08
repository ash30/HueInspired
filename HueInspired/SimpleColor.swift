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
}
