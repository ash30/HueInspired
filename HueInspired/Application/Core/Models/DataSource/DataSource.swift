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
import PromiseKit



protocol GenericDataSource: class {
    
    var observer: DataSourceObserver? { get set }
    var sections: [(String,Int)] { get }

    func save() throws
    
}

protocol PaletteDataSource: GenericDataSource {
    
    func getElement(at index:Int, section sectionIndex:Int) -> ColorPalette?
    
}

protocol UserPaletteDataSource: GenericDataSource, PaletteDataSource {
    
    func getElement(at index:Int, section sectionIndex:Int) -> UserOwnedPalette?
    
}

protocol ManagedPaletteDataSource: GenericDataSource, PaletteDataSource, UserPaletteDataSource {
    
    func getElement(at index:Int, section sectionIndex:Int) -> CDSColorPalette?
}




