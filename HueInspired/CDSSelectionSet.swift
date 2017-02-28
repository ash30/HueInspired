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

// MARK: INIT

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

// MARK: Fetch Results

extension CDSSelectionSet {
    
    func fetchMembers () -> NSFetchedResultsController<CDSColorPalette>? {
        guard let context = managedObjectContext else {
            return nil
        }
        
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        fetch.fetchBatchSize = 50
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        fetch.predicate = NSPredicate(format: "sets contains %@", argumentArray: [self])
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil
        )
        return controller
    }
    
    
}
