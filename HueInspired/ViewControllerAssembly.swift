//
//  CoreViewControllerAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 25/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import UIKit
import CoreData

// This is what I would like to do... it requires a UIViewController protocol though
// typealias PaletteDetailViewFactory = () -> (UserPaletteDetails & UIViewController)
typealias PaletteDetailViewFactory = () -> PaletteDetailViewController

class ViewControllerAssembly: Assembly {
    
    func assemble(container: Container) {
     
        // MARK: DETAIL VIEW CONTROLLER
        
        container.register(UserManagedPaletteDetailDelegate.self) { (r:Resolver, ctx:NSManagedObjectContext) in
            let favs = try? PaletteFavourites.getSelectionSet(for: ctx)
            return UserManagedPaletteDetailDelegate(context:ctx)
        }
        
        // MARK: FACTORY
        
        container.register(PaletteDetailViewFactory.self) { r in
            return {
                let vc = PaletteDetailViewController()
                let persistentData: NSPersistentContainer = r.resolve(NSPersistentContainer.self)!
                vc.delegate = r.resolve(UserManagedPaletteDetailDelegate.self, argument:persistentData.viewContext)!
                return vc
            }
        }
        
        
        
    }
    
}
