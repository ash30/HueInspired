//
//  ImmutablePalette+UserOwnedPalette.swift
//  HueInspired
//
//  Created by Ashley Arthur on 08/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

extension ImmutablePalette: UserOwnedPalette {
    
    // Can Never! be favourited as its not a managed entity
    
    var isFavourite: Bool {
        get{
            return false
        }
        set {
            
        }
    }
}
