//
//  ImageLoader.swift
//  HueInspired
//
//  Created by Ashley Arthur on 31/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

// The idea is to standardised image input so we can run an color extractor over it.
// This requires us to have a fixed size and pixel data layout.

import Foundation
import CoreGraphics

func createFixedSizedSRGBThumb(image:CGImage, size:Int = 512) -> CGImage? {
    
    let colorspace = CGColorSpace.init(name: CGColorSpace.sRGB)!
    
    
    let bitmapInfo: CGBitmapInfo = [
        CGBitmapInfo.byteOrder32Big,
        //CGBitmapInfo.alphaInfoMask
    ]
    let finalBitmapInfo = bitmapInfo.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
    
    let context = CGContext.init(
        data: nil,
        width: size,
        height: size,
        bitsPerComponent: 8,
        bytesPerRow: 0,  // should auto calculate
        space: colorspace,
        bitmapInfo: finalBitmapInfo
    )
    context?.draw(image, in: CGRect.init(x: 0, y: 0, width: size, height: size), byTiling: false)
    return context?.makeImage()
}

func extractPixelData(image:CGImage) -> [SimpleColor]? {
    guard let backingStore = image.dataProvider?.data else {
        return nil
    }
    let rawData = Data(
        bytes: CFDataGetBytePtr(backingStore),
        count: CFDataGetLength(backingStore)
    )
    
    return rawData.withUnsafeBytes { (ptr:UnsafePointer<UInt8>) -> [SimpleColor] in
        
        let count =  CGFloat(rawData.count)
        
        return stride(from:ptr, to: ptr.advanced(by:Int(count)), by: 4).map{
            (p: UnsafePointer<UInt8>) -> SimpleColor in
            let r = p.pointee
            let g = p.successor().pointee
            let b = p.successor().successor().pointee
            let a = p.successor().successor().successor().pointee
            return SimpleColor(r: Int(r), g: Int(g), b: Int(b), a: Int(a))
        }
    }
}
