//
//  CDSColorPalette+CoreDataProperties.swift
//  HueInspired
//
//  Created by Ashley Arthur on 14/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData


extension CDSColorPalette {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSColorPalette> {
        return NSFetchRequest<CDSColorPalette>(entityName: "CDSColorPalette");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var colors: NSOrderedSet?
    @NSManaged public var source: CDSColorSource?

}

// MARK: Generated accessors for colors
extension CDSColorPalette {

    @objc(insertObject:inColorsAtIndex:)
    @NSManaged public func insertIntoColors(_ value: CDSColor, at idx: Int)

    @objc(removeObjectFromColorsAtIndex:)
    @NSManaged public func removeFromColors(at idx: Int)

    @objc(insertColors:atIndexes:)
    @NSManaged public func insertIntoColors(_ values: [CDSColor], at indexes: NSIndexSet)

    @objc(removeColorsAtIndexes:)
    @NSManaged public func removeFromColors(at indexes: NSIndexSet)

    @objc(replaceObjectInColorsAtIndex:withObject:)
    @NSManaged public func replaceColors(at idx: Int, with value: CDSColor)

    @objc(replaceColorsAtIndexes:withColors:)
    @NSManaged public func replaceColors(at indexes: NSIndexSet, with values: [CDSColor])

    @objc(addColorsObject:)
    @NSManaged public func addToColors(_ value: CDSColor)

    @objc(removeColorsObject:)
    @NSManaged public func removeFromColors(_ value: CDSColor)

    @objc(addColors:)
    @NSManaged public func addToColors(_ values: NSOrderedSet)

    @objc(removeColors:)
    @NSManaged public func removeFromColors(_ values: NSOrderedSet)

}
