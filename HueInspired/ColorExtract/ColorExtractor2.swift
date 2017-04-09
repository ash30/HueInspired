//
//  ColorExtractor2.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import simd


struct FnColor {
    
    let xyz: vector_double3
    let srgb: vector_double3
    let cielab: vector_double3
    
    init(fromSRGB r:Int, g:Int, b:Int){

        let _r = Double(r) / 255.0
        let _g = Double(g) / 255.0
        let _b = Double(b) / 255.0
        
        srgb = vector_double3(_r, _g, _b)
        xyz = SRGB_TO_XYZ(srgb)
        cielab = XYZ_TO_CIELAB(xyz, referenceWhite: vector_double3(0.95047, 1.00, 1.08883)) //hardcoded to srgb white space
    }
    
    init(fromLAB l: Double, a:Double, b:Double){
        cielab = vector_double3(l,a,b)
        xyz = CIELAB_TO_XYZ(cielab, referenceWhite: vector_double3(0.95047, 1.00, 1.08883))
        srgb = XYZ_TO_SRGB(xyz)
    }
    
}

fileprivate struct VectorHash: Equatable, Hashable {
    let element: vector_double3

    static func ==(lhs: VectorHash, rhs: VectorHash) -> Bool {

        return  lhs.element.x == rhs.element.x &&
                lhs.element.y == rhs.element.y &&
                lhs.element.z == rhs.element.z
    }
    var hashValue: Int {
        return [element.x, element.y, element.z].map { Int($0) }.reduce(0){$0 ^ $1}
    }
}

func SampleImage(sourceImage: UIImage) -> [FnColor]? {
    guard
        let image = sourceImage.cgImage,
        let fixedSizeInput = createFixedSizedSRGBThumb(image: image, size: 100),
        let pixelData = extractPixelData(image:fixedSizeInput),
        pixelData.count > 3
        else {
            return nil // this didn't work
    }

    let colors = pixelData.map { FnColor(fromSRGB: $0.r, g: $0.g, b: $0.b) }
    let tree = KDNodeTree.init(points: colors.map {$0.cielab}, maxDepth:3)!

    var candidates = [VectorHash:Int]()
    for node in tree {
        candidates[VectorHash.init(element: node)] = 0
    }
    for color in colors {
        let vote = VectorHash(element:tree.searchNearest(color.cielab))
        guard let currentCount = candidates[vote] else {
            continue
        }
        candidates[vote] = currentCount + 1
    }
    
    // Sort Candidates by popularity and return them mapped as Colors
    let sampleColors = candidates.map { $0 }.sorted { (a:(key: VectorHash, count: Int), b:(key: VectorHash, count: Int)) -> Bool in
        a.count >= b.count
    }.map { (a:(key: VectorHash, value: Int)) -> FnColor in
        FnColor.init(fromLAB: a.key.element.x, a: a.key.element.y, b: a.key.element.z)
    }
    
    var w: [(Double,FnColor)] = []
    for (i,sample) in sampleColors.enumerated(){
        
        let posWeight = Double(sampleColors.count - i)
        let differenceWeight = w[0..<min(w.count,6)].map{
            distance_squared($1.cielab, sample.cielab)
        }.reduce(0.1){ $0 + $1}
        
        let finalWeight = posWeight * differenceWeight
        w.append((finalWeight, sample))
    }
    
    
    return w.sorted { (a:(weight:Double, FnColor), b:(weight:Double, FnColor)) -> Bool in
        a.weight >= b.weight
    }
    .map { (w:Double, elem:FnColor) -> FnColor in
        return elem
    }

    
}


