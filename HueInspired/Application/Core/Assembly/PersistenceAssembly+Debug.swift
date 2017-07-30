//
//  PersistenceAssembly+Debug.swift
//  HueInspired
//
//  Created by Ashley Arthur on 22/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import CoreData

extension PersistenceAssembly {
    
    // DEBUG Method to clear test content
    static func clearDatabaseContent(persistenceContainer:NSPersistentContainer){
        
        for entitiy in [CDSColor.self, CDSColorPalette.self, CDSImageSource.self] as [NSManagedObject.Type] {
            
            let fetchRequest = entitiy.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try persistenceContainer.persistentStoreCoordinator.execute(
                    deleteRequest, with: persistenceContainer.viewContext
                )
                
            } catch let error as NSError {
                let e = error
                print(e)
            }
        }
    }
    
    static func clearUserPreferences(bundle:String?){
        if let bundle = bundle ?? Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
    
}
