//
//  PaletteViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 26/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

protocol PaletteViewController: class {
   
    var delegate: PaletteCollectionDelegate? { get set }
    var dataSource: PaletteSpecDataSource? { get set }
}
