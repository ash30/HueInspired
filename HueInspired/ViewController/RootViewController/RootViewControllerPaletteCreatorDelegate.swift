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


class RootViewControllerPaletteCreatorDelegate: PaletteCreatorDelegate {
    
    // MARK: PROPERTIES
    var factory: ColorPaletteDataSourceFactory
    
    init(factory: @escaping ColorPaletteDataSourceFactory){
        self.factory = factory
    }
    
    // MARK: METHODS
    
    func createPaletteFromUserImage(image: UIImage, id:String) -> Promise<ColorPalette> {
     
        let p = Promise<ColorPalette>.pending()
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                let palette = ImmutablePalette(withRepresentativeSwatchesFrom: image, name: nil, guid:id)
                else {
                    p.reject(PaletteErrors.paletteCreationFailure)
                    return
            }
            p.fulfill(palette)
        }
        
        return p.promise
        
    }    
    
    func didSelectUserImage(creator:UIViewController, image: UIImage, id:String){
        
        // Setup View controller to transition to
        
        let containerVC =  ActionContainer()
        containerVC.action = { _ in 
            // Bit of Hack, we want to dismiss image picker + detailer, so we reach back...
            creator.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        containerVC.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: creator, action: #selector(creator.targetDismiss)
        )
        
        containerVC.actionButtonText = "Save"
        
        let navVC = UINavigationController()
        navVC.viewControllers = [containerVC]
        
        // Setup Palette Detail
        let paletteVC = PaletteDetailViewController()
        containerVC.addChildViewController(paletteVC)
        
        _ = createPaletteFromUserImage(image: image, id: id).then { [weak paletteVC, weak self] (p:ColorPalette) -> () in
            guard
                let _self = self,
                let dataSource = _self.factory(p) else {
                throw PaletteErrors.paletteCreationFailure
            }
            paletteVC?.dataSource = dataSource
        }
            .catch { [weak paletteVC] (e:Error) in
            paletteVC?.report(error: e)
        }
        
        navVC.modalTransitionStyle = .flipHorizontal
        creator.present(navVC, animated: true)
        
        
        
    }
    
    
//    func createPaletteFromUserImage(ctx:NSManagedObjectContext, image: UIImage, id:String) -> Promise<NSManagedObjectID> {
//        
//        let p = Promise<NSManagedObjectID>.pending()
//        
//        ctx.perform  {
//            
//            guard
//                let palette = ImmutablePalette(withRepresentativeSwatchesFrom: image, name: nil, guid:id)
//                else {
//                    p.reject(PaletteErrors.paletteCreationFailure)
//                    return
//            }
//            do{
//                let paletteEntity = CDSColorPalette(context: ctx, palette: palette)
//                try ctx.save()
//                p.fulfill(paletteEntity.objectID)
//            }
//            catch let error as NSError {
//                // This may fail due to palette existing already!
//                // If so we fulfil promise with existing
//                
//                // TODO: Proper Constants for error
//                
//                guard
//                    error.code == 133021,
//                    error.domain == "NSCocoaErrorDomain",
//                    let conflicts = error.userInfo["conflictList"] as? [NSConstraintConflict],
//                    conflicts.count == 1
//                    else {
//                        // Unrecoginised error
//                        p.reject(error)
//                        return
//                }
//                
//                // TODO: Currently we can assume a one to one map
//                // between palette and image source. This may not hold
//                // forever...
//                
//                guard
//                    let original_imagesource = conflicts[0].databaseObject as? CDSImageSource,
//                    let original_palette = original_imagesource.palette
//                    
//                    else {
//                        // can't recover from the error...
//                        p.reject(error)
//                        return
//                }
//                p.fulfill(original_palette.objectID)
//            }
//        }
//        return p.promise
//    }
    
}

extension UIViewController {
    
    @objc func targetDismiss(sender:UIControl) {
        dismiss(animated: true, completion: nil)
    }
    
}
