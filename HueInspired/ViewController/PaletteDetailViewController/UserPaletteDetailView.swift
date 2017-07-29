//
//  PaletteDetailProtocol.swift
//  HueInspired
//
//  Created by Ashley Arthur on 12/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

/*
 
 A public interface to hide the PaletteDetailViewController behind
 
 Client code is only really expected to supply data, the implementing VC
 will do the rest
 
*/

protocol UserPaletteDetailView: class {
        
    var dataSource: UserPaletteDataSource? { get set }
    
}
