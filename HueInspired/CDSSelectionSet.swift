//
//  CDSSelectionSet.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData


@objc(CDSSelectionSet)
public final class CDSSelectionSet: NSManagedObject, CustomManagedObject {
    
    static let entityName: String = "CDSSelectionSet"

    @NSManaged public internal(set) var name: String
    @NSManaged public internal(set) var palettes: Set<CDSColorPalette>
    
}

extension CDSSelectionSet {
    
    // Create a Palette from a given set of colors
    
    convenience init(context:NSManagedObjectContext, name:String) {
        
        if let description = NSEntityDescription.entity(forEntityName: "CDSSelectionSet", in: context) {
            self.init(entity: description, insertInto: context)
            self.name = name
        }
        else {
            fatalError("Unknown Entity Description")
        }
               
    }
    
}


// MARK: MEMBERSHIP 

extension CDSSelectionSet {
    
    func addPalette(_ palette:CDSColorPalette){
        palettes.insert(palette)
    }
    
    func removePalette(_ palette:CDSColorPalette){
        palettes.remove(palette)
    }
    
    func contains(_ palette: CDSColorPalette) -> Bool {
        return palettes.contains(palette)
    }
    
}
