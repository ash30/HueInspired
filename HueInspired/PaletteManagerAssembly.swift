//
//  PaletteManagerAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 25/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import UIKit
import CoreData

class PaletteManagerAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: TABLE DELEGATES
        
        container.register(MasterDetailTableDelegate.self) { r in
            return MasterDetailTableDelegate(
                factory: r.resolve(ColorPaletteDataSourceFactory.self)!,
                detailViewFactory: r.resolve(PaletteDetailViewFactory.self)!
            )
        }
  
        
    }
}
