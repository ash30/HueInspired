//
//  DataSources+Filtered.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/06/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

protocol DataSourceFilter{
    
    func filterData(by term:String)
    func clearFilter()
    func replaceOriginalFilter(_ predicate:NSPredicate)
    
}
