//
//  CoreDataUtils.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData


extension NSFetchRequest {
    
    var defaultFetchBatchSize: Int {
        return 50
    }
    
}

protocol CustomManagedObject: class {
    static var entityName: String { get }
}

extension CustomManagedObject where Self: NSManagedObject {
    static func fetchRequest() -> NSFetchRequest<Self> {
        let fetch = NSFetchRequest<Self>(entityName: Self.entityName)
        fetch.fetchBatchSize = fetch.defaultFetchBatchSize
        return fetch
    }
}
