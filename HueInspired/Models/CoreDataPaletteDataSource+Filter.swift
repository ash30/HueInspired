//
//  DataSourceCoreData+Searchable.swift
//  HueInspired
//
//  Created by Ashley Arthur on 02/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

extension CoreDataPaletteDataSource: DataSourceFilter {
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
}
