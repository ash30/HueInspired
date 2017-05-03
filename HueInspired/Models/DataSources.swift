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

protocol DataSourceObserver: class  {
    
    func dataDidChange(currentState:DataSourceState)
}

protocol GenericDataSource: class {
    
    var observer: DataSourceObserver? { get set }
    var count: Int { get }
    
    func syncData()
    func syncData(waitFor event:Promise<Bool>)
    func filterData(by term:String)
    func clearFilter()
    func replaceOriginalFilter(_ predicate:NSPredicate)
    
}

protocol PaletteDataSource: GenericDataSource {
    
    func getElement(at index:Int) -> ColorPalette?
    
}

protocol PaletteSpecDataSource: GenericDataSource, PaletteDataSource {
    
    func getElement(at index:Int) -> UserOwnedPalette?
    
}

protocol ManagedPaletteDataSource: GenericDataSource, PaletteDataSource, PaletteSpecDataSource {
    
    func getElement(at index:Int) -> CDSColorPalette?
}




