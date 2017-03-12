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


class CoreDataPaletteDataSource: NSObject, PaletteDataSource, ManagedPaletteDataSource, PaletteSpecDataSource, NSFetchedResultsControllerDelegate {
    

    
    // MARK: PROPERTIES
    
    let dataController: NSFetchedResultsController<CDSColorPalette>
    var observer: DataSourceObserver?
    var favourites: CDSSelectionSet?
    
    var dataState: DataSourceState = .initiated {
        didSet{
            DispatchQueue.main.async {
                self.observer?.dataDidChange()
            }
        }
    }
    let originalPredicate:NSPredicate?
    
    // MARK: INIT  
    
    init(data:NSFetchedResultsController<CDSColorPalette>, favourites:CDSSelectionSet?){
        
        self.dataController = data
        originalPredicate = data.fetchRequest.predicate
        self.favourites = favourites
        super.init()
        dataController.delegate = self
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.resetFetchController),
            name: Notification.Name.init(rawValue: "replace"), object: nil)
        
        
    }
    
    // MARK: FETCH CONTROLLER DELEGATE
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        observer?.dataDidChange()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        print("here")
    }
    
    // MARK: DATA SOURCE
    func syncData() {
        syncData(notify: true)
    }
    
    func syncData(notify:Bool) {
        if notify == true {dataState = .pending}
        
        // Give VCs a chance to react by asyncing fetch
        DispatchQueue.main.async {
            do {
                try self.dataController.performFetch()
                self.dataState = .furfilled
            }
            catch {
                self.dataState = .errored(error)
            }
        }
    }
    
    @objc
    func resetFetchController(){
        syncData(notify: false)
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
        if let cacheName = dataController.cacheName {
            NSFetchedResultsController<CDSColorPalette>.deleteCache(withName: cacheName)
        }
        let predicate = NSPredicate(
            format: ((dataController.fetchRequest.predicate?.predicateFormat ?? "") + " AND name BEGINSWITH %@"), argumentArray: [term]
        )
        dataController.fetchRequest.predicate = predicate
        syncData()
    }
    
    func clearFilter(){
        if let cacheName = dataController.cacheName {
            NSFetchedResultsController<CDSColorPalette>.deleteCache(withName: cacheName)
        }
        dataController.fetchRequest.predicate = originalPredicate
        syncData()
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
    
    func getElement(at index: Int) -> PaletteSpec? {
        guard
            let palette: CDSColorPalette = getElement(at: index)
            else {
                return nil
        }
        
        // FIXME: Need to reconnect favourites
        let isFav = favourites?.contains(palette) ?? false 
        
        // FIXME: Convert to convenience init
        return PaletteSpec(name: palette.name, colorData: palette.colorData, image: palette.image, isFavourite: isFav)
    }
    
}

