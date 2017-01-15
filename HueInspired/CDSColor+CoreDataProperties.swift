//
//  CDSColor+CoreDataProperties.swift
//  HueInspired
//
//  Created by Ashley Arthur on 14/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData


extension CDSColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSColor> {
        return NSFetchRequest<CDSColor>(entityName: "CDSColor");
    }

    @NSManaged public var blue: Int16
    @NSManaged public var green: Int16
    @NSManaged public var red: Int16
    @NSManaged public var palettes: NSSet?

}

// MARK: Generated accessors for palettes
extension CDSColor {

    @objc(addPalettesObject:)
    @NSManaged public func addToPalettes(_ value: CDSColorPalette)

    @objc(removePalettesObject:)
    @NSManaged public func removeFromPalettes(_ value: CDSColorPalette)

    @objc(addPalettes:)
    @NSManaged public func addToPalettes(_ values: NSSet)

    @objc(removePalettes:)
    @NSManaged public func removeFromPalettes(_ values: NSSet)

}
