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

fileprivate let INVERSE_SRGB_WORKINGSPACE = matrix_double3x3(
    columns:(
        vector_double3(3.2404542, -0.9692660, 0.0556434),
        vector_double3(-1.5371385, 1.8760108, -0.2040259),
        vector_double3(-0.4985314, 0.0415560, 1.0572252)
    )
)


func inverseCompandingSRGB(_ value:Double) -> Double {
    return value <= 0.04045 ? (value / 12.92) : pow((value + 0.055) / 1.055, 2.4)
}

func compandingSRGB(_ value:Double) -> Double {
    return value <= 0.0031308 ? 12.92 * value : (1.055 * pow(value, 1/2.4)) - 0.055
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

func CIELAB_TO_XYZ(_ vec: vector_double3, referenceWhite:vector_double3) -> vector_double3 {
    
    let e = 0.008856
    let k = 903.3
    
    let fy = (vec.x + 16) / 116
    let fz = fy - (vec.z / 200)
    let fx = (vec.y / 500 ) + fy
    
    let x = pow(fx,3.0) > e ? pow(fx,3.0) : ((116 * fx) - 16) / k
    let y = vec.x > (k*e) ? pow((vec.x + 16) / 116, 3.0) : vec.x / k
    let z = pow(fz, 3.0) > e ? pow(fz, 3.0) : ((116 * fz) - 16) / k
    
    return vector_double3([
        x * referenceWhite.x,
        y * referenceWhite.y,
        z * referenceWhite.z
    ])
}

func XYZ_TO_SRGB(_ vec: vector_double3) -> vector_double3 {

    let rbg = matrix_multiply(INVERSE_SRGB_WORKINGSPACE, vec)
    return vector3(
        compandingSRGB(rbg.x),
        compandingSRGB(rbg.y),
        compandingSRGB(rbg.z)
    )
    
}




