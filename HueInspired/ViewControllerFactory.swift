//
//  ViewControllerFactory.swift
//  HueInspired
//
//  Created by Ashley Arthur on 03/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


class ViewControllerFactory {
    
    static private func loadFromStoryBoard(id:String, storyBoardName:String = "Main") -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        return vc
    }
    
    private func setupPaletteViewController(application: AppController, dataSource:CoreDataPaletteDataSource, vcIdent:String, title:String?) -> UIViewController {
        
        let vc = ViewControllerFactory.loadFromStoryBoard(id: vcIdent)
        vc.title = title
        let controller = PaletteCollectionController(appController: application, viewModel: dataSource, viewControllerFactory: self)
        
        guard let paletteVC = vc as? PaletteViewController else{
            return vc
        }
        paletteVC.delegate = controller
        paletteVC.dataSource = dataSource
                
        return vc
    }
    
    func showPaletteCollection(application: AppController, dataSource:CoreDataPaletteDataSource, title:String?=nil) -> UIViewController {
        return setupPaletteViewController(application: application, dataSource: dataSource, vcIdent: "PaletteTable1", title:title)
    }
    
    func showPalette(application: AppController, dataSource:CoreDataPaletteDataSource, title:String?=nil) -> UIViewController {
        return setupPaletteViewController(application: application, dataSource: dataSource, vcIdent: "PaletteDetail1",title:title)
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
