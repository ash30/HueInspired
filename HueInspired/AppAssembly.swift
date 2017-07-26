//
//  ViewControllerAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import UIKit
import CoreData


class AppAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: ROOT VIEW
        
        container.storyboardInitCompleted(ActionContainer.self){ r, vc in
            let storyBoard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: r)
            let child = storyBoard.instantiateViewController(withIdentifier: "Main")
            let imagePicker = UIImagePickerController()
            let adapter = ImagePickerDelegatePaletteCreatorBridge()
            adapter.controller = RootViewControllerPaletteCreatorDelegate(factory: r.resolve(ColorPaletteDataSourceFactory.self, name:"Temp")!)
            
            vc.action = { _self in
                imagePicker.delegate = adapter // capture adapter
                _self.present(imagePicker, animated: true)
            }
            vc.actionButtonText = "+"
            vc.addChildViewController(child)
        }
        
        container.storyboardInitCompleted(MultipleDataTableViewController.self, name: "Main"){ r, vc in
            
            let tableVC = PaletteTableViewController()
            tableVC.paletteCollectionName = "HueInspired"
            vc.setTableView(tableVC)
            
            tableVC.delegate = r.resolve(TrendingPaletteDelegate.self)
            
            // Data Source
            let all = r.resolve(UserPaletteDataSource.self, name:DataSourceAssembly.DataSourceConfig.all.rawValue)!
            let favs = r.resolve(UserPaletteDataSource.self, name:DataSourceAssembly.DataSourceConfig.favs.rawValue)!
            
            // VC Config
            vc.dataSources = [("All",all),("Favourites",favs)]
            
            
        }
        
        // TODO: Rewrite without relying on core data
        
        container.storyboardInitCompleted(PaletteTableViewController.self, name: "TrendingTable"){ r, vc in
            
            // Delgate
            vc.delegate = r.resolve(TrendingPaletteDelegate.self)!
            
            // Data Source
            let dataSource = r.resolve(UserPaletteDataSource.self, name:DataSourceAssembly.DataSourceConfig.all.rawValue)!
            
            vc.dataSource = dataSource
            dataSource.observer = vc
            
            // VC Config
            vc.paletteCollectionName = "HueInspired"
            
        }
        
        container.storyboardInitCompleted(PaletteTableViewController.self, name: "FavouritesTable"){ r, vc in
            
            
            // Delgate
            vc.delegate = r.resolve(PaletteFavouritesDelegate.self)!
            
            let dataSource = r.resolve(UserPaletteDataSource.self, name:DataSourceAssembly.DataSourceConfig.favs.rawValue)!
            vc.dataSource = dataSource
            dataSource.observer = vc
            
            // VC Config
            vc.paletteCollectionName = "Favourites"
            
        }

        
        
    }
    
    
}
