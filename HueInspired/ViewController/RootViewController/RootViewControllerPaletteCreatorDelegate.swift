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
        
        // Setup Container VC

        let containerVC =  ActionContainer()
        containerVC.actionButtonText = "Save"
        containerVC.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: creator, action: #selector(creator.targetDismiss)
        )
        
        // Setup Palette Detail

        let paletteVC = PaletteDetailViewController()
        containerVC.addChildViewController(paletteVC)
        
        _ = createPaletteFromUserImage(image: image, id: id).then { [weak containerVC, weak paletteVC, weak self] (p:ColorPalette) -> () in
            guard
                let _self = self,
                let dataSource = _self.factory(p) else {
                    throw PaletteErrors.paletteCreationFailure
            }
            paletteVC?.dataSource = dataSource
            
            containerVC?.action = { vc in
                do {
                    try dataSource.save()
                    // Bit of Hack, we want to dismiss image picker + detailer, so we reach back...
                    creator.presentingViewController?.dismiss(animated: true, completion: nil)
                }
                catch let error as NSError {
                    guard
                        error.code == 133021,
                        error.domain == "NSCocoaErrorDomain",
                        let conflicts = error.userInfo["conflictList"] as? [NSConstraintConflict]
                        else {
                            vc.report(error: error)
                            return // Unknown error ...
                    }
                    vc.showErrorAlert(title: "Duplicate palette", message: "Palette Already exists in your collection")
                }
            }
        }
        .catch { [weak paletteVC] (e:Error) in
                paletteVC?.report(error: e)
        }
        
        
        let navVC = UINavigationController()
        navVC.viewControllers = [containerVC]
        navVC.modalTransitionStyle = .flipHorizontal
        creator.present(navVC, animated: true)
        
        
        
    }
    
}

extension UIViewController {
    
    @objc func targetDismiss(sender:UIControl) {
        dismiss(animated: true, completion: nil)
    }
    
}
