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


class CoreDataPaletteDataSource: NSObject, PaletteDataSource, ManagedPaletteDataSource, NSFetchedResultsControllerDelegate {
    
    // MARK: PROPERTIES
    
    let dataController: NSFetchedResultsController<CDSColorPalette>
    var observer: DataSourceObserver?
    
    
    // MARK: INIT
    
    init(data:NSFetchedResultsController<CDSColorPalette>){
        self.dataController = data
        super.init()
        dataController.delegate = self
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.syndDataObserver),
            name: Notification.Name.init(rawValue: "replace"), object: nil)
        
        
    }
    
    // MARK: FETCH CONTROLLER DELEGATE
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        observer?.dataDidChange()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        
    }
    
    // MARK: DATA SOURCE
    
    func syncData() {
        try? dataController.performFetch()
    }
    
    @objc
    func syndDataObserver(){
        syncData()
        
        DispatchQueue.main.async {
            self.observer?.dataDidChange()
        }
    }
    
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
    
}

