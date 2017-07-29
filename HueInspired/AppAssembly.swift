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
                
        container.storyboardInitCompleted(ActionContainer.self){ r, vc in
            let storyBoard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: r)
            let child = storyBoard.instantiateViewController(withIdentifier: "Main")
            let imagePicker = UIImagePickerController()
            let pickerDelegate = r.resolve(UserImagePaletteCreator.self)
            
            vc.action = { _self in
                imagePicker.delegate = pickerDelegate // captured
                _self.present(imagePicker, animated: true)
            }
            vc.actionButtonText = "+"
            vc.addChildViewController(child)
        }
        
        container.storyboardInitCompleted(MultipleDataTableViewController.self, name: "Main"){ r, vc in
            
            let tableVC = PaletteTableViewController()
            tableVC.paletteCollectionName = "HueInspired"
            vc.setTableView(tableVC)
            
            let tableDelegate = r.resolve(MasterDetailTableDelegate.self)!
            tableDelegate.delegate = r.resolve(TrendingPaletteCreator.self)!
            tableVC.delegate = tableDelegate
            
            // Data Source
            let all = r.resolve(UserPaletteDataSource.self, name:DataSourceAssembly.DataSourceConfig.all.rawValue)!
            let favs = r.resolve(UserPaletteDataSource.self, name:DataSourceAssembly.DataSourceConfig.favs.rawValue)!
            
            // VC Config
            vc.dataSources = [("All",all),("Favourites",favs)]
            
            
        }

    }
    
    
}
