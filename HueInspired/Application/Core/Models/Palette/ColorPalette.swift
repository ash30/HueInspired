//
//  Palettes.swift
//  HueInspired
//
//  Created by Ashley Arthur on 31/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// An interface so we can decouple the view layer from our NSManaged objects

protocol ColorPalette  {
    
    var name: String? { get }
    var image: UIImage? { get }
    var colorData: [DiscreteRGBAColor] { get }
    var guid: String? { get }
    
}

extension ColorPalette {
    var guid:String? {
        return nil
    }
}

// User facing palettes can have meta data assigned to help User
// organise them. This data is mutable unlike the palette

protocol UserOwnedPalette: ColorPalette {
    var isFavourite: Bool { get set }
}



