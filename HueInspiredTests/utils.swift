//
//  utils.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData

func setupDataStack() -> NSPersistentContainer {
    // Thanks: http://stackoverflow.com/questions/39004864/ios-10-core-data-in-memory-store-for-unit-tests#39005210
    
    let testDataStack = NSPersistentContainer(name: "HueInspired")
    
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    testDataStack.persistentStoreDescriptions = [description]
    
    testDataStack.loadPersistentStores{ (storeDescription, error) in
        if error != nil { fatalError() }
    }
    return testDataStack
}
