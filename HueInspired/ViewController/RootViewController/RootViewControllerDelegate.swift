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
    
    typealias DetailDataSourceFactory = (NSManagedObjectContext, NSManagedObjectID) -> CoreDataPaletteDataSource
    
    // MARK: PROPERTIES
    var persistentData: NSPersistentContainer
    var factory: DetailDataSourceFactory
    
    // MARK: STATE
    var lastUserCreatedPalettee: Promise<NSManagedObjectID>?
    
    init( persistentData:NSPersistentContainer , factory: @escaping DetailDataSourceFactory){
        self.persistentData = persistentData
        self.factory = factory
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
    
    func didSelectUserImage(viewController:UIViewController, image: UIImage){
        
        // Get detail controller from factory
        lastUserCreatedPalettee = createPaletteFromUserImage(ctx: persistentData.viewContext, image:image)

    }
    
    func willPresentDetail(viewController: UIViewController){
        
        if let vc = viewController as? PaletteDetailViewController {
            vc.delegate = UserManagedPaletteDetailDelegate(context:persistentData.viewContext )
            vc.dataSource = lastUserCreatedPalettee?.then {
                self.factory(self.persistentData.viewContext, $0)
            }
        }
    }
}
