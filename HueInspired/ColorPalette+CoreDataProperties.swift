//
//  ColorPalette+CoreDataProperties.swift
//  HueInspired
//
//  Created by Ashley Arthur on 14/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData


extension ColorPalette {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorPalette> {
        return NSFetchRequest<ColorPalette>(entityName: "ColorPalette");
    }

    @NSManaged public var name: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var source: ColorSource?
    @NSManaged public var colors: NSOrderedSet?

}

// MARK: Generated accessors for colors
extension ColorPalette {

    @objc(insertObject:inColorsAtIndex:)
    @NSManaged public func insertIntoColors(_ value: Color, at idx: Int)

    @objc(removeObjectFromColorsAtIndex:)
    @NSManaged public func removeFromColors(at idx: Int)

    @objc(insertColors:atIndexes:)
    @NSManaged public func insertIntoColors(_ values: [Color], at indexes: NSIndexSet)

    @objc(removeColorsAtIndexes:)
    @NSManaged public func removeFromColors(at indexes: NSIndexSet)

    @objc(replaceObjectInColorsAtIndex:withObject:)
    @NSManaged public func replaceColors(at idx: Int, with value: Color)

    @objc(replaceColorsAtIndexes:withColors:)
    @NSManaged public func replaceColors(at indexes: NSIndexSet, with values: [Color])

    @objc(addColorsObject:)
    @NSManaged public func addToColors(_ value: Color)

    @objc(removeColorsObject:)
    @NSManaged public func removeFromColors(_ value: Color)

    @objc(addColors:)
    @NSManaged public func addToColors(_ values: NSOrderedSet)

    @objc(removeColors:)
    @NSManaged public func removeFromColors(_ values: NSOrderedSet)

}
