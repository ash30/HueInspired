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
        
        // MARK: MULTI TABLE VIEW
        
        container.register(MultipleDataTableViewController.self){ r in
            
            let vc = MultipleDataTableViewController()
            let tableVC = PaletteTableViewController()
            tableVC.paletteCollectionName = "HueInspired"
            vc.setTableView(tableVC)
            
            // Data Source
            let all = r.resolve(UserPaletteDataSource.self, name:DataSourceAssembly.DataSourceConfig.all.rawValue)!
            let favs = r.resolve(UserPaletteDataSource.self, name:DataSourceAssembly.DataSourceConfig.favs.rawValue)!
            
            vc.dataSources = [("All",all),("Favourites",favs)]
            return vc
        }
  
        
    }
}
