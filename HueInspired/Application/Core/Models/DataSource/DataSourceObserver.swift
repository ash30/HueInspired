//
//  DataSourceObserver.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/06/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

enum DataSourceChange {
    case refresh
    case add(IndexPath)
}

protocol DataSourceObserver: class  {
    
    func dataDidChange(currentState:DataSourceChange)
}
