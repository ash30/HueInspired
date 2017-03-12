//
//  ViewControllerFactory.swift
//  HueInspired
//
//  Created by Ashley Arthur on 03/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ViewControllerFactory {
    
    static private func loadFromStoryBoard(id:String, storyBoardName:String = "Main") -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        return vc
    }

    func showPaletteCollection(application: AppController, context:NSManagedObjectContext?, title:String?=nil) -> UIViewController {
        let vc = PaletteTableViewController()
        let controller = PaletteCollectionController.init(appController: application, viewControllerFactory: self, context: context ?? application.persistentData.viewContext)
        vc.delegate = controller
        vc.title = title
        return vc
    }
    
    func showFavourites(application: AppController, context:NSManagedObjectContext?, title:String?=nil) -> UIViewController {
        let vc = PaletteTableViewController()
        let controller = PaletteFavouritesController.init(appController: application, viewControllerFactory: self, context: context ?? application.persistentData.viewContext)
        vc.delegate = controller
        vc.title = title
        return vc
    }
    
    func showPalette(application: AppController, dataSource:CoreDataPaletteDataSource, title:String?=nil) -> UIViewController {
        let vc = ViewControllerFactory.loadFromStoryBoard(id: "PaletteDetail1") as! PaletteDetailViewController
        let controller = PaletteDetailController(appController: application, viewModel: dataSource, viewControllerFactory: self)
        vc.delegate = controller
        vc.dataSource = dataSource
        vc.title = title
        return vc
    }
    
    func showRoot(application: AppController) -> UIViewController{
        let controller = RootController(
            viewControllerFactory: self,
            appController: application
        )
        let vc = RootViewController(controller: controller)
        return vc
    }
    
}
