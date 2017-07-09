//
//  TrendingPaletteService.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit

protocol TrendingPaletteService {
    
    func nextPalette() -> Promise<ColorPalette>
    
}
