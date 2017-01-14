//
//  Color+CoreDataProperties.swift
//  HueInspired
//
//  Created by Ashley Arthur on 14/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData


extension Color {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Color> {
        return NSFetchRequest<Color>(entityName: "Color");
    }

    @NSManaged public var red: Int16
    @NSManaged public var green: Int16
    @NSManaged public var blue: Int16
    @NSManaged public var palettes: NSSet?

}

// MARK: Generated accessors for palettes
extension Color {

    @objc(addPalettesObject:)
    @NSManaged public func addToPalettes(_ value: ColorPalette)

    @objc(removePalettesObject:)
    @NSManaged public func removeFromPalettes(_ value: ColorPalette)

    @objc(addPalettes:)
    @NSManaged public func addToPalettes(_ values: NSSet)

    @objc(removePalettes:)
    @NSManaged public func removeFromPalettes(_ values: NSSet)

}
