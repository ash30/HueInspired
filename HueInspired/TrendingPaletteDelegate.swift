//
//  PaletteCollectionViewModel.swift
//  HueInspired
//
//  Created by Ashley Arthur on 31/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit



// MARK: CONTROLLER


protocol PaletteCollectionDelegate {
    
    func didLoad(viewController:UIViewController)
    func didSelectPalette(viewController:UIViewController, index:Int)
    func didPullRefresh(tableRefresh:UIRefreshControl)
    
}

class PaletteCollectionController: PaletteCollectionDelegate, PaletteSync {
    
    var viewControllerFactory: ViewControllerFactory
    var appController: AppController
    weak var viewModel: ManagedPaletteDataSource?
    
    // cached locally to save fetching
    let favourites: CDSSelectionSet?
    
    init(appController:AppController, viewModel:ManagedPaletteDataSource, viewControllerFactory: ViewControllerFactory){
        self.appController = appController
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        
        favourites = try! appController.favourites.getSelectionSet(for: appController.mainContext)
        
    }
    
    convenience init(appController:AppController, viewControllerFactory:ViewControllerFactory){
        
        // FIXME: HANDLE FAIL
        let favouritesSet = try! appController.favourites.getSelectionSet(for: appController.persistentData.viewContext)
        let favourites = favouritesSet.fetchMembers()!
        favourites.fetchRequest.sortDescriptors = [ .init(key:"creationData", ascending:true)]
        let model = CoreDataPaletteDataSource(data: favourites, favourites: favouritesSet)
        self.init(appController:appController, viewModel:model, viewControllerFactory: viewControllerFactory)
        
    }
    
    func didSelectPalette(viewController:UIViewController, index:Int){
        
        guard
            let palette = viewModel?.getElement(at: index),
            let ctx = palette.managedObjectContext,
            let favs = try? appController.favourites.getSelectionSet(for: ctx)
        else {
            return // FIXME: SHOULD PROBABLY WARN USER...
        }
        
        let data = CDSColorPalette.getPalettes(ctx: ctx, ids: [palette.objectID])
        let vc = viewControllerFactory.showPalette(
            application: appController,
            dataSource: CoreDataPaletteDataSource(data: data, favourites: favourites!)
        )
        viewController.show(vc, sender: self)
    }

    func didLoad(viewController:UIViewController){
        viewModel?.dataState = .pending
        
        _ = syncLatestPalettes().then { _ in
            
            self.viewModel?.dataState = .furfilled
            
            
            }.catch(execute: { (error:Error) in
                // FIXME: WE SHOULD REALLY LET THE VC KNOW
                self.viewModel?.dataState = .errored(error)
                print("Refresh Error")
            })
    }
    
    func didPullRefresh(tableRefresh:UIRefreshControl){
        viewModel?.dataState = .pending
        _ = syncLatestPalettes().then { _ in
            
            self.viewModel?.dataState = .furfilled

            
        }.catch(execute: { (error:Error) in
            // FIXME: WE SHOULD REALLY LET THE VC KNOW 
            self.viewModel?.dataState = .errored(error)
            print("Refresh Error")
        })
    }
    
}





