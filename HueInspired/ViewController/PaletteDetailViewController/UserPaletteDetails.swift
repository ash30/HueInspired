//
//  PaletteDetailProtocol.swift
//  HueInspired
//
//  Created by Ashley Arthur on 12/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

/*
 A shared interface for palette detail view controllers
 
 delegate methods for setting up presented detail vc will use this type
 to guarantee calling code provides a vc they expect
 
*/

protocol UserPaletteDetails: class {
        
    var dataSource: UserPaletteDataSource? { get set }
    
}
