//
//  PaletteDetailViewController+UserPaletteDetails.swift
//  HueInspired
//
//  Created by Ashley Arthur on 13/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit

extension PaletteDetailViewController: UserPaletteDetails {
    
    
    var data:UserPaletteDataSource? {
        get {
            return dataSource?.value
        }
        set(value) {
            guard let d = value else{
                return
            }
            dataSource = Promise<UserPaletteDataSource>.init(value: d)
        }
    }
    
    
}
