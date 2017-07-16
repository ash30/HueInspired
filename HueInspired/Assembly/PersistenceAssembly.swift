//
//  PersistenceAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import CoreData

class PersistenceAssembly: Assembly {
    
    func assemble(container: Container) {

        // MARK: PERSISTENT CONTAINER

        container.register(NSPersistentContainer.self) { _ in
            
            let persistentData = NSPersistentContainer(name: "HueInspired")
            persistentData.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            persistentData.viewContext.mergePolicy = NSMergePolicy.rollback
            persistentData.viewContext.automaticallyMergesChangesFromParent = true
            
            return persistentData
            
            }.inObjectScope(.container)
     }
}
