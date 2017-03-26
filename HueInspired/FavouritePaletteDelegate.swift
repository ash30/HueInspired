//
//  FavouritePaletteDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 07/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PaletteFavouritesController: PaletteCollectionDelegate {
    
    var dataSource: ManagedPaletteDataSource?
    
    init(dataSource:ManagedPaletteDataSource){
        self.dataSource = dataSource
    }
    
    func didPullRefresh(tableRefresh:UIRefreshControl){
        tableRefresh.endRefreshing()
    }
    
}
