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
        fetch.sortDescriptors = [NSSortDescriptor.init(key: #keyPath(CDSColorPalette.creationDate), ascending: true)]
        fetch.predicate = NSPredicate(
            format: "ANY %K == %@", argumentArray: [#keyPath(CDSColorPalette.sets.name),self.name]
        )
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil
        )
        return controller
    }
    
}

typealias PaletteFavourites = CDSSelectionSet

extension PaletteFavourites {
    
    static func getSelectionSet(for ctx:NSManagedObjectContext) throws -> CDSSelectionSet {
        
        let setName = "favourites"  // Is there a better place to keep this??
        
        let request: NSFetchRequest<CDSSelectionSet> = CDSSelectionSet.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(CDSSelectionSet.name), setName])
        
        let selectionSet: CDSSelectionSet? = try ctx.fetch(request).first
        
        // Predicate didn't error but we didn't find any object so we create one
        // We should probably make this more explicit
        
        if let set = selectionSet {
            return set
        }
        else {
            let selectionSet = CDSSelectionSet(context: ctx, name: setName)
            try ctx.save()
            return selectionSet
        }
    }
}

