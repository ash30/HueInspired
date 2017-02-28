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


protocol FavouritesManager {
    
    var persistentData: NSPersistentContainer { get }
    
    func getFavourites(for ctx:NSManagedObjectContext) throws -> CDSSelectionSet
    
}

extension FavouritesManager {
    
    func getFavourites(for ctx:NSManagedObjectContext) throws -> CDSSelectionSet {
        
        let setName = "Favourites"  // Is there a better place to keep this??
        
        let request: NSFetchRequest<CDSSelectionSet> = CDSSelectionSet.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", argumentArray: [setName])
        
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





