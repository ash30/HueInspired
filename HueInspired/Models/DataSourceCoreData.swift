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


/*
 
 To implement sections, you need to setup input controller with key path
 
 In general, we should tidy up this mess of a class
 
 1. Favourites
 I think it would be better if the protocol extension managed this, it can get the id 
 from the favourites static class and simply check its own selections set 
 
 2. We need to expose sections counts and names AND also a way to get count per section
 All this should be optional 
 
 d) replaceOriginalFilter
 I wonder if this can be replaced and simplified
 
 
 The value in the data source is:
 
 a) it encompases data and error handling in one source so the VC can just render based on its 
 current state. 
 
 b) It also half attempts to model long running actions which can be reported to the vc
 so it can render an animation spinner as needed.
 
 c) it encloses around filtering of the data source
 it would be better if this was broken up into a wrapper around the data source object, transparent to it
 
------
 We should generalise filtering thing so we can remove one more method from data source.
 
 
*/


class CoreDataPaletteDataSource: NSObject, PaletteDataSource, ManagedPaletteDataSource, PaletteSpecDataSource, NSFetchedResultsControllerDelegate {
    
    // MARK: PROPERTIES
    
    let dataController: NSFetchedResultsController<CDSColorPalette>
    weak var observer: DataSourceObserver?
    
    var dataState: DataSourceState = .initiated {
        didSet{
            DispatchQueue.main.async {
                self.observer?.dataDidChange(currentState: self.dataState)
            }
        }
    }
    var originalPredicate:NSPredicate?
    let workQueue = DispatchQueue.init(label: "dataSource_work")
    
    // MARK: INIT  
    
    init(data:NSFetchedResultsController<CDSColorPalette>){
        
        self.dataController = data
        originalPredicate = data.fetchRequest.predicate
        super.init()
        dataController.delegate = self
        
    }
    
    // MARK: FETCH CONTROLLER DELEGATE
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        observer?.dataDidChange(currentState: self.dataState)
    }

    // MARK: DATA SOURCE
    
    func syncData() {
        workQueue.async {
            self.dataState = .pending
        }
        
        workQueue.async {
            do {
                try self.dataController.performFetch()
                self.dataState = .furfilled
            }
            catch {
                self.dataState = .errored(error)
            }
        }
    }
    
    func syncData<T>(waitFor event:Promise<T>){
        // We serialise access so we can ensure observer
        // is notified in correct order
        
        let lock = DispatchSemaphore(value: 0)
        
        workQueue.async(){
            self.dataState = .pending
            lock.wait()
        }
        event.then{ (_:T) -> () in
            do {
                try self.dataController.performFetch()
                self.dataState = .furfilled
            }
            catch {
                self.dataState = .errored(error)
            }
            }
            .catch { (error: Error) in
                self.dataState = .errored(error)
            }
            .always {
                lock.signal()
        }
    }


    var count: Int {
        var i = 0
        dataController.managedObjectContext.performAndWait {
            i = self.dataController.fetchedObjects?.count ?? 0
        }
        return i
    }
    
    // MARK: FILTER ING
    
    func filterData(by term:String) {
        // Clear any currently applied
        clearFilter()
        
        if let cacheName = dataController.cacheName {
            NSFetchedResultsController<CDSColorPalette>.deleteCache(withName: cacheName)
        }
        let predicate = NSPredicate(
            format: ((dataController.fetchRequest.predicate?.predicateFormat ?? "") + " AND %K CONTAINS %@"), argumentArray: [#keyPath(CDSColorPalette.name),term]
        )
        dataController.fetchRequest.predicate = predicate
    }
    
    func clearFilter(){
        if let cacheName = dataController.cacheName {
            NSFetchedResultsController<CDSColorPalette>.deleteCache(withName: cacheName)
        }
        dataController.fetchRequest.predicate = originalPredicate
    }
    
    func replaceOriginalFilter(_ predicate:NSPredicate){
        dataController.fetchRequest.predicate = predicate
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

