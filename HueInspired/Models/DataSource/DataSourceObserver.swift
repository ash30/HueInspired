//
//  DataSourceObserver.swift
//  HueInspired
//
//  Created by Ashley Arthur on 30/06/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

// I feel the pending state is too transient to be modeled as a part 
// of DataSourceState

// It was the reason for the whole Dispatch Queue, so we can make sure 
// the state transitions correctly to the consquence of previous call
// otherwise errors maybe missed
// e.g if we're waiting on a promise, a sync call to syncData would
// transition to fuliflled and then we wouldn't get a pending state

// The main goal was to have data source object properlly show
// pending state 


enum DataSourceState {
    case initiated
    case pending
    case furfilled
    case errored(Error)
}

protocol DataSourceObserver: class  {
    
    func dataDidChange(currentState:DataSourceState)
}
