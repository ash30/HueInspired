//
//  PaletteFavouritesManager.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import CoreData


class FavouritesManager {

    static let defaultSelectionSetName = "favourites"
    
    internal let mainContext: NSManagedObjectContext
    internal let favSelectionSet: CDSSelectionSet
    
    init(mainContext: NSManagedObjectContext, selectionSet:CDSSelectionSet) {
        self.mainContext = mainContext
        self.favSelectionSet = selectionSet
    }
    
}

// MARK: INIT

extension FavouritesManager {
    
    convenience init?(context:NSManagedObjectContext){
        
        let request: NSFetchRequest<CDSSelectionSet> = CDSSelectionSet.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", argumentArray: [FavouritesManager.defaultSelectionSetName])
        
        var selectionSet: CDSSelectionSet? = nil
        do {
            selectionSet = try context.fetch(request).first
        }
        catch {
            return nil
        }
        
        // Predicate didn't error but we didn't find any object so we create one
        // We should probably make this more explicit
        
        if selectionSet == nil {
            selectionSet = CDSSelectionSet(context: context, name: FavouritesManager.defaultSelectionSetName)
            try? context.save()
        }
        if let selectionSet = selectionSet {
            self.init(mainContext:context, selectionSet: selectionSet)
        }
        else{
            return nil
        }
    }
    
}

// MARK: Favourites methods

extension FavouritesManager {
    
    func addFavourite(_ palette:CDSColorPalette) throws {
        do {
            favSelectionSet.addPalette(palette)
            try self.mainContext.save()
        }
    }
    
    func removeFavourite(_ palette:CDSColorPalette) throws {
        do {
            favSelectionSet.removePalette(palette)
            try self.mainContext.save()
        }
    }
    
    func isfavourite(_ palette:CDSColorPalette) -> Bool {
        return favSelectionSet.contains(palette)
    }

}

extension FavouritesManager {
    
    func getFavourites() -> NSFetchedResultsController<CDSColorPalette> {
        
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        fetch.fetchBatchSize = 50
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        fetch.predicate = NSPredicate(format: "sets contains %@", argumentArray: [favSelectionSet])
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: mainContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        return controller
    }


}



