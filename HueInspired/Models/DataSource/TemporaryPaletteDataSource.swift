//
//  TemporaryPaletteDataSource.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData

// We often need to create objects on a background context as form of scratch pad
// This we can validate uniqueness before merging into main context
// Problem: You can really use NSFetchResultsController with non viewContext
// Hence we create an alternative implementation that uses value based palettes

class TemporaryPaletteDataSource: UserPaletteDataSource {
    
    var data: ColorPalette?
    var observer: DataSourceObserver?
    
    private var context: NSManagedObjectContext?
    
    init(context:NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: DATA SOURCE

    var sections: [(String,Int)] {
        return [ (data?.name ?? "", data != nil ? 1 : 0)]
    }
    
    func getElement(at index:Int, section sectionIndex:Int) -> ColorPalette? {
        return data
    }
    
    func getElement(at index: Int, section sectionIndex:Int = 0) -> UserOwnedPalette? {
        guard let data = data else {
            return nil
        }
        return ImmutablePalette(name: data.name, colorData: data.colorData, image: data.image, guid: data.guid)
    }
    
    func save() throws {
        guard let context = context, let data = data else{
            return
        }
        _ = CDSColorPalette(context: context, palette: data)
        try context.save()
    }
    
    
}
