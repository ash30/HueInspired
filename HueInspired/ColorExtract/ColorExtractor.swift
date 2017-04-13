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

fileprivate func SampleImage(sourceImage: UIImage, sampleDepth:Int=7) -> [VectorHash]? {
    guard
        let image = sourceImage.cgImage,
        let fixedSizeInput = createFixedSizedSRGBThumb(image: image, size: 100),
        let pixelData = extractPixelData(image:fixedSizeInput),
        pixelData.count > 3
        else {
            return nil // this didn't work
    }

    let colors = pixelData.map { FnColor(fromSRGB: $0.r, g: $0.g, b: $0.b) }
    let tree = KDNodeTree.init(points: colors.map {$0.cielab}, maxDepth:sampleDepth)!

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
        abs(a.key.element.y) + abs(a.key.element.z) >=  abs(b.key.element.y) + abs(b.key.element.z)
    }.map { (a:(key: VectorHash, value: Int)) -> VectorHash in
        return a.key
    }
    
    return sampleColors
}

func SampleImage(sourceImage: UIImage) -> [FnColor]? {
    guard let samples:[VectorHash] = SampleImage(sourceImage:sourceImage ) else {
        return nil
    }
    return generatePalette(samples)
}


fileprivate func generatePalette(_ samples: [VectorHash], size:Int=6, convergence:Double=5.0, maxIter:Int=5) -> [FnColor] {
    
    // We know the initial samples are sorted by population
    // so we bias our centoids to the middle of 
    let lower = 0
    let upper = samples.count / 2
    let rangeOfInterestStep = (upper - lower) / size
    
    var centoids = (0...size).map { lower + ( $0 * rangeOfInterestStep) }.map {samples[$0].element}
    var centoidMovement: Double = 0.0
    var iterations = 0
    
    repeat {
        
        var bins = [[VectorHash]].init(repeating: [], count: centoids.count)
        
        // Assign each sample to nearest center's bin
        for s in samples {
            let distances = centoids.map {
                distance_squared(s.element, $0)
            }
            let closetsbyIndex = distances.enumerated().sorted { (a:(index:Int, distance: Double), b:(index:Int, distance: Double)) in
                a.distance < b.distance
            }.first!.offset
            
            bins[closetsbyIndex].append(s)
        }
        
        // Work out average position in each bin
        let newCentoids = bins.map { (bin:[VectorHash]) -> vector_double3 in
            let sum = bin.reduce(vector3(0.0,0.0,0.0)){$0 + $1.element}
            return vector3(sum.x / Double(bin.count), sum.y / Double(bin.count), sum.z / Double(bin.count))
        }
        
        // update centoids
        centoidMovement = zip(centoids, newCentoids).map { distance_squared($0, $1)}.reduce(0.0){$0 + $1}
        centoids = newCentoids
        iterations += 1
        
    } while centoidMovement > convergence || iterations <= maxIter
    
    
    return centoids.map {
        FnColor.init(fromLAB: $0.x, a: $0.y, b: $0.z)
    }
    
    
}


