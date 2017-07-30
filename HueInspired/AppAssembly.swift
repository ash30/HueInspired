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
            
            let tableVC = r.resolve(MultipleDataTableViewController.self)
            let tableDelegate = r.resolve(MasterDetailTableDelegate.self)
            tableDelegate?.delegate = r.resolve(TrendingPaletteCreator.self)
            tableVC?.delegate = tableDelegate
                        
            // If Palette Manager featuer is enabled, display table
            if let tableVC = tableVC {
                vc.addChildViewController(tableVC)
            }

            // If Palette Creation feature is enabled
            guard let paletteCreator = r.resolve(PaletteCreationMenuViewController.self, argument:vc as UIViewController) else {
                return
            }
            vc.action = { _self in
                _self.present(paletteCreator, animated: true)
            }
            vc.actionButtonText = "+"
        }
    }
    
    
}
