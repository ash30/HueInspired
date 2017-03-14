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

enum DataSourceState {
    case initiated
    case pending
    case furfilled
    case errored(Error)
}

protocol DataSourceObserver {
    
    func dataDidChange()
}

protocol GenericDataSource: class {
    
    var observer: DataSourceObserver? { get set }
    var dataState: DataSourceState { get set }
    var count: Int { get }
    
    func syncData()
    func syncData(event:Promise<Bool>)
    func filterData(by term:String)
    func clearFilter()
    func replaceOriginalFilter(_ predicate:NSPredicate)
    
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




