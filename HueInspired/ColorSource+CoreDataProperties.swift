//
//  ColorSource+CoreDataProperties.swift
//  HueInspired
//
//  Created by Ashley Arthur on 14/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData


extension ColorSource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorSource> {
        return NSFetchRequest<ColorSource>(entityName: "ColorSource");
    }

    @NSManaged public var type: String?
    @NSManaged public var image: NSData?
    @NSManaged public var query: String?
    @NSManaged public var palettes: NSSet?

}

// MARK: Generated accessors for palettes
extension ColorSource {

    @objc(addPalettesObject:)
    @NSManaged public func addToPalettes(_ value: ColorPalette)

    @objc(removePalettesObject:)
    @NSManaged public func removeFromPalettes(_ value: ColorPalette)

    @objc(addPalettes:)
    @NSManaged public func addToPalettes(_ values: NSSet)

    @objc(removePalettes:)
    @NSManaged public func removeFromPalettes(_ values: NSSet)

}
