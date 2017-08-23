//
//  ImageSource.swift
//  HueInspired
//
//  Created by Ashley Arthur on 24/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreGraphics

@objc(CDSImageSource)
public final class CDSImageSource: NSManagedObject, CustomManagedObject {
    
    static let entityName: String = "CDSImageSource"
    
    @NSManaged public internal(set) var imageData: Data?
    @NSManaged public internal(set) var thumbnail: Data?
    @NSManaged public internal(set) var externalID: String
    @NSManaged public internal(set) var palette: CDSColorPalette?
    
}


extension CDSImageSource {
    
    convenience init(context:NSManagedObjectContext, id:String, palette: CDSColorPalette?, imageData:Data?){
        
        if let description = NSEntityDescription.entity(forEntityName: CDSImageSource.entityName, in: context) {
            self.init(entity: description, insertInto: context)
            
            self.imageData = imageData
            self.externalID = id
            self.palette = palette

        }
            
        else {
            fatalError("Unknown Entity Description")
        }
    }
    
}
