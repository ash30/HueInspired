//
//  CDSColorPalette.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData



@objc(CDSColorPalette)
public final class CDSColorPalette: NSManagedObject, CustomManagedObject {
    
    static let entityName: String = "CDSColorPalette"
    
    @NSManaged public internal(set) var source: CDSImageSource?
    @NSManaged public internal(set) var colors: NSOrderedSet
    @NSManaged public var name: String?
    @NSManaged public internal(set) var creationDate: Date?
    @NSManaged public internal(set) var sets: Set<CDSSelectionSet>?
    
}

// MARK: Implement Color Palette Interface

extension CDSColorPalette: ColorPalette {
    
    var image: UIImage? {
        guard
            let imageSource = source,
            let data = imageSource.imageData
        else {
            return nil
        }
        // FIXME: Do we want to cache this?
        return UIImage(data: data as Data)
    }
    
    var colorData: [DiscreteRGBAColor] {
        return colors.array as! [DiscreteRGBAColor]
    }
    
    var guid:String? {
        return source?.externalID
    }
}

// MARK: Inits

extension CDSColorPalette {

    // Create a Palette from a given set of colors
    
    convenience init(context:NSManagedObjectContext, name:String?, colors: [CDSColor]){
        
        if let description = NSEntityDescription.entity(forEntityName: CDSColorPalette.entityName, in: context) {
            self.init(entity: description, insertInto: context)
            
            self.name = name
            self.colors = NSOrderedSet(array: colors)
            creationDate = Date()
        }
            
        else {
            fatalError("Unknown Entity Description")
        }
    }
    
    convenience init(context:NSManagedObjectContext, palette:ColorPalette){
    
        let colors = palette.colorData.map {
            CDSColor.init(context: context, color: $0)
        }
        self.init(context:context, name: palette.name, colors: colors)
        
        if let id = palette.guid, let data = palette.image?.cgImage?.dataProvider?.data{
            source  = CDSImageSource(context: context, id: id, palette:self, imageData:data as Data)
        }
    
    }

    
}

extension CDSColorPalette {
    
    static func getPalettes(ctx: NSManagedObjectContext, ids:[NSManagedObjectID] = []) -> NSFetchedResultsController<CDSColorPalette> {
        
        let fetch: NSFetchRequest<CDSColorPalette> = CDSColorPalette.fetchRequest()
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        fetch.sortDescriptors = [NSSortDescriptor.init(key: #keyPath(creationDate), ascending: true)]
        
        if ids.count > 0 {
            fetch.predicate = NSPredicate(format: "self IN %@", ids)
        }
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: ctx,
            sectionNameKeyPath: nil, cacheName: nil
        )
        return controller
    }
    
}





