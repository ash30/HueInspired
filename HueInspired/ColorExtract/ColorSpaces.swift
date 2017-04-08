//
//  ColorBox2.swift
//  HueInspired
//
//  Created by Ashley Arthur on 08/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import simd


fileprivate let SRGB_WORKINGSPACE = matrix_double3x3(
    columns:(
        vector3(0.4124564, 0.2126729, 0.0193339),
        vector3(0.3575761, 0.7151522, 0.1191920),
        vector3(0.1804375, 0.0721750, 0.9503041)
    )
)

func inverseCompandingSRGB(_ value:Double) -> Double {
    return value <= 0.04045 ? (value / 12.92) : pow((value + 0.055) / 1.055, 2.4)
}

func SRGB_TO_XYZ(_ vec: vector_double3) -> vector_double3 {
    
    let linearComponents = vector3(
        inverseCompandingSRGB(vec.x),
        inverseCompandingSRGB(vec.y),
        inverseCompandingSRGB(vec.z)
    )
    return matrix_multiply(SRGB_WORKINGSPACE, linearComponents)
}

func XYZ_TO_CIELAB(_ vec: vector_double3, referenceWhite:vector_double3) -> vector_double3 {
    
    let e = 0.008856
    let k = 903.3
    
    let x = vec.x / referenceWhite.x
    let y = vec.y / referenceWhite.y
    let z = vec.z / referenceWhite.z
    
    let fx = x > e ? pow(x, 1/3) : ((k * x) + 16) / 116
    let fy = y > e ? pow(y, 1/3) : ((k * y) + 16) / 116
    let fz = z > e ? pow(z, 1/3) : ((k * z) + 16) / 116
    
    let l = (116 * fy) - 16
    let a = 500 * (fx - fy)
    let b = 200 * (fy - fz)
    
    return vector_double3([l,a,b])
}

