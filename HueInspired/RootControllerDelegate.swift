//
//  RootViewControllerDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 28/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit
import CoreData

protocol RootViewControllerDelegate {
    func didSelectUserImage(viewController:UIViewController, image: UIImage)
    func willPresentDetail(viewController: UIViewController)
}

class RootController: RootViewControllerDelegate {
    
    typealias DetailControllerFactory = (NSManagedObjectContext) -> PaletteDetailController
    
    // MARK: PROPERTIES
    var persistentData: NSPersistentContainer
    var detailControllerFactory: DetailControllerFactory
    
    // MARK: STATE
    var selectedController: PaletteDetailController?
    
    init( persistentData:NSPersistentContainer , detailControllerFactory: @escaping DetailControllerFactory){
        self.persistentData = persistentData
        self.detailControllerFactory = detailControllerFactory
    }
    
    // MARK: METHODS
    
    func createPaletteFromUserImage(ctx:NSManagedObjectContext, image:UIImage) -> Promise<NSManagedObjectID> {
        
        let p = Promise<NSManagedObjectID>.pending()
        
        ctx.perform  {
            guard
                let palette = ImmutablePalette(withRepresentativeSwatchesFrom: image, name: nil)
                else {
                    p.reject(PaletteErrors.paletteCreationFailure)
                    return
            }
            do{
                let paletteEntity = CDSColorPalette(context: ctx, palette: palette)
                try ctx.save()
                p.fulfill(paletteEntity.objectID)
            }
            catch {
                p.reject(error)
            }
        }
        return p.promise
    }
    
    /*
 
        we need to await the creation of a palette 
     
        we need to segue first
        then update the
     
    */
    
    func didSelectUserImage(viewController:UIViewController, image: UIImage){
        
        // Get detail controller from factory
        let ctx = persistentData.newBackgroundContext()
        let detailController = detailControllerFactory(ctx)
        let data = detailController.dataSource as! CoreDataPaletteDataSource

        // create new palette based on selected image
        let event = createPaletteFromUserImage(ctx:ctx, image:image).then { [weak data] (id:NSManagedObjectID) -> Bool in
            data?.replaceOriginalFilter(NSPredicate(format: "self IN %@", [id]))
            return true
        }
        data.syncData(event: event)
        selectedController = detailController // save for later prepare call
    }
    
    func willPresentDetail(viewController: UIViewController){
        
        if let vc = viewController as? PaletteDetailViewController {
            vc.delegate = selectedController
            vc.dataSource = selectedController?.dataSource as! PaletteSpecDataSource // FIXME
        }
        
    }


}
