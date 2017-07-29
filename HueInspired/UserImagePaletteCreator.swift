//
//  PaletteImagePicker.swift
//  HueInspired
//
//  Created by Ashley Arthur on 28/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// FIXME: Data Source Needs to handle error
import CoreData

// IMAGE PICKER, TRANFORM IMAGE PICKED INTO PALETTE! 

class UserImagePaletteCreator: NSObject {
    var creator: PaletteCreator?
    
    var factory: ColorPaletteDataSourceFactory
    
    init(factory: @escaping ColorPaletteDataSourceFactory){
        self.factory = factory
    }
    
    
    func didSelectUserImage(picker:UIViewController, image: UIImage, id:String){
        
        // Setup Container VC
        
        let containerVC =  ActionContainer()
        containerVC.actionButtonText = "Save"
        containerVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: picker, action: #selector(picker.targetDismiss)
        )
        
        // Setup Palette Detail
        
        let paletteVC = PaletteDetailViewController()
        containerVC.addChildViewController(paletteVC)
        
        _ = creator?.createFrom(image: image, id: id).then { [weak containerVC, weak paletteVC, weak self] (p:ColorPalette) -> () in
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
                    picker.presentingViewController?.dismiss(animated: true, completion: nil)
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
        picker.present(navVC, animated: true)
        
        
        
    }
    
}

extension UserImagePaletteCreator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let
            newImage = info["UIImagePickerControllerOriginalImage"] as? UIImage,
            let path = (info["UIImagePickerControllerReferenceURL"] as? NSURL)?.absoluteString
            else {
                return
        }
        didSelectUserImage(picker:picker, image:newImage, id:path.toBase64())
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true)
    }
}
