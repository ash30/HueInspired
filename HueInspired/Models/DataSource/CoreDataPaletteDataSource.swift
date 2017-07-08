//
//  PaletteDataSource.swift
//  HueInspired
//
//  Created by Ashley Arthur on 21/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData 
import PromiseKit


class CoreDataPaletteDataSource: NSObject, NSFetchedResultsControllerDelegate {
    
    // MARK: PROPERTIES
    
    let dataController: NSFetchedResultsController<CDSColorPalette>
    weak var observer: DataSourceObserver?
    let workQueue = DispatchQueue.init(label: "dataSource_work")
    
    // MARK: INIT  
    
    init(data:NSFetchedResultsController<CDSColorPalette>){
        
        self.dataController = data
        super.init()
        dataController.delegate = self
        
    }
    
    // MARK: FETCH CONTROLLER DELEGATE
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        // FIXME: REPORT CHANGES PROPERLLY 
        observer?.dataDidChange(currentState:.furfilled)
    }

    // MARK: DATA SOURCE
    
    func syncData() throws {
        try workQueue.sync {
            try self.dataController.performFetch()
            observer?.dataDidChange(currentState:.furfilled)
        }
    }
}

extension CoreDataPaletteDataSource: PaletteDataSource, ManagedPaletteDataSource, UserPaletteDataSource {
    
    var count: Int {
        var i = 0
        dataController.managedObjectContext.performAndWait {
            i = self.dataController.fetchedObjects?.count ?? 0
        }
        return i
    }
    
    // MARK: GETTERS
    
    func getElement(at index:Int) -> CDSColorPalette? {
        var palette: CDSColorPalette?
        dataController.managedObjectContext.performAndWait {
            guard
                let results = self.dataController.fetchedObjects,
                index < results.count
                else {
                    return
            }
            palette = results[index]
        }
        return palette
    }
    
    func getElement(at index:Int) -> ColorPalette? {
        guard
            let palette: CDSColorPalette = getElement(at: index)
            else {
                return nil
        }
        return palette
    }
    
    func getElement(at index: Int) -> UserOwnedPalette? {
        guard
            let palette: CDSColorPalette = getElement(at: index)
            else {
                return nil
        }
        return palette
    }
    
}


