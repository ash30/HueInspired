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
    
    // For Filters
    fileprivate var defaultPredicate: NSPredicate?
    
    
    // MARK: INIT  
    
    init(data:NSFetchedResultsController<CDSColorPalette>){
        
        self.dataController = data
        self.defaultPredicate = data.fetchRequest.predicate
        super.init()
        dataController.delegate = self
        
    }
    
    // MARK: FETCH CONTROLLER DELEGATE
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                observer?.dataDidChange(currentState:.refresh)
                return
            }
            observer?.dataDidChange(currentState:.add(newIndexPath))
        default:
            observer?.dataDidChange(currentState:.refresh)
        }
        
    }

    // MARK: DATA SOURCE
    
    func syncData() throws {
        try self.dataController.performFetch()
        observer?.dataDidChange(currentState:.refresh)
    }
}

extension CoreDataPaletteDataSource: ManagedPaletteDataSource {
    
    var sections: [(String,Int)] {
        
        guard let sections = dataController.sections else {
            return [("",dataController.fetchedObjects?.count ?? 0 )]
        }
        return sections.map {
            return ($0.name, $0.numberOfObjects )
        }
    }
    
    // MARK: GETTERS
    
    func getElement(at index:Int, section sectionIndex:Int = 0) -> CDSColorPalette? {

        if let sections = dataController.sections {
            guard
                sectionIndex < sections.count
            else {
                return nil
            }
            let section = sections[sectionIndex]
            
            guard let objects = section.objects, index < objects.count else {
                return nil
            }
            
            return objects[index] as? CDSColorPalette
        }
        return nil 
    }
    
    func getElement(at index:Int, section sectionIndex:Int = 0) -> ColorPalette? {
        guard
            let palette: CDSColorPalette = getElement(at: index, section:sectionIndex)
            else {
                return nil
        }
        return palette
    }
    
    func getElement(at index: Int, section sectionIndex:Int = 0) -> UserOwnedPalette? {
        guard
            let palette: CDSColorPalette = getElement(at: index, section:sectionIndex)
            else {
                return nil
        }
        return palette
    }
    
    // MARK: SAVE
    
    func save() throws {
        if dataController.managedObjectContext.hasChanges {
            try dataController.managedObjectContext.save()
        }
        
    }
    
}

// MARK: FILTERs

extension CoreDataPaletteDataSource: DataSourceFilter {
    
    func filterData(by term:String) {
        // Clear any currently applied
        clearFilter()
        
        if let cacheName = dataController.cacheName {
            NSFetchedResultsController<CDSColorPalette>.deleteCache(withName: cacheName)
        }
        
        let predicate = NSPredicate(
            format: (
                (dataController.fetchRequest.predicate?.predicateFormat ?? "") +
                    (((dataController.fetchRequest.predicate?.predicateFormat ?? "").characters.count > 0) ? " AND " : "") +
                "%K CONTAINS %@"
            ), argumentArray: [#keyPath(CDSColorPalette.name),term]
        )
        dataController.fetchRequest.predicate = predicate
        try? dataController.performFetch()
    }
    
    func clearFilter(){
        if let cacheName = dataController.cacheName {
            NSFetchedResultsController<CDSColorPalette>.deleteCache(withName: cacheName)
        }
        dataController.fetchRequest.predicate = defaultPredicate
        try? dataController.performFetch()
    }
    
    func replaceOriginalFilter(_ predicate:NSPredicate){
        defaultPredicate = predicate
    }
}


