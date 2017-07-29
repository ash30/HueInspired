//
//  ActionContainer+UserPaletteDetails.swift
//  HueInspired
//
//  Created by Ashley Arthur on 20/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

// Allow Action Container to decorate UserPalette Detail view
// This should be moved to a conditional Conformance come swift 4

extension ActionContainer: UserPaletteDetailView {
    
    var dataSource: UserPaletteDataSource? {
        get{
            guard childViewControllers.count > 0 else{
                return nil
            }
            return (childViewControllers[0] as? UserPaletteDetailView)?.dataSource
        }
        set(data) {
            guard
                childViewControllers.count > 0,
                let vc = childViewControllers[0] as? UserPaletteDetailView
            else{
                print("No DataSource Item to ")
                return
            }
                vc.dataSource = data
        }
    }
}
    


