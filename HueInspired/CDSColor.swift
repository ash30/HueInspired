//
//  CDSColor.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData

extension CDSColor {
    
    convenience init (context: NSManagedObjectContext, color: DiscreteRGBAColor ){
        
        if let description = NSEntityDescription.entity(forEntityName: "CDSColor", in: context) {
            self.init(entity: description, insertInto: context)
            red = Int16(color.r)
            green = Int16(color.g)
            blue = Int16(color.b)
        }
        else {
            fatalError("Unknown Entity Description")
        }

    }
    
}


extension CDSColor: DiscreteRGBAColor {
    var r: Int {
        return Int(red)
    }
    var g: Int {
        return Int(green)
    }
    var b: Int {
        return Int(blue)
    }
    var a: Int {
        return 1
    }
}
