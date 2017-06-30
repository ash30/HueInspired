//
//  DataSourceObserver.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/06/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

enum DataSourceState {
    case initiated
    case pending
    case furfilled
    case errored(Error)
}

protocol DataSourceObserver: class  {
    
    func dataDidChange(currentState:DataSourceState)
}
