//
//  PaletteCreator2.swift
//  HueInspired
//
//  Created by Ashley Arthur on 28/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit


protocol PaletteCreator {
    
    func createFrom(image: UIImage, id:String) -> Promise<ColorPalette>
    
}

enum PaletteErrors: Error {
    case paletteCreationFailure
}

