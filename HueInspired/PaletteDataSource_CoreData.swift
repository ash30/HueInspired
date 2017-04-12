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

class CoreDataPaletteDataSource: NSObject, PaletteDataSource, ManagedPaletteDataSource, PaletteSpecDataSource, NSFetchedResultsControllerDelegate {
    
    // MARK: PROPERTIES
    
    let dataController: NSFetchedResultsController<CDSColorPalette>
    weak var observer: DataSourceObserver?
    
    var dataState: DataSourceState = .initiated {
        didSet{
            DispatchQueue.main.async {
                self.observer?.dataDidChange()
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
        observer?.dataDidChange()
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
    
    func syncData(event:Promise<Bool>){
        
        let lock = DispatchSemaphore(value: 0)
        workQueue.async(){
            self.dataState = .pending
            lock.wait()
        }
        event.then{ (flag:Bool) -> () in
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

