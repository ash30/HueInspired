//
//  PaletteDataSource.swift
//  HueInspired
//
//  Created by Ashley Arthur on 28/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol DataSourceObserver {
    
    func dataDidChange()
}

protocol GenericDataSource: class {
    // associatedtype Element
    
    var observer: DataSourceObserver? { get set }
    var count: Int { get }
    
    func syncData()
    
}

protocol PaletteDataSource: GenericDataSource {
    
    func getElement(at index:Int) -> ColorPalette?
    
}

protocol PaletteSpecDataSource: GenericDataSource {
    
    func getElement(at index:Int) -> PaletteSpec?
    
}

protocol ManagedPaletteDataSource: GenericDataSource {
    
    func getElement(at index:Int) -> CDSColorPalette?

}




