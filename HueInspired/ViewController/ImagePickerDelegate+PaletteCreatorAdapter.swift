//
//  ImagePickerDelegate+PaletteCreatorAdapter.swift
//  HueInspired
//
//  Created by Ashley Arthur on 23/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// Bridges between image picker delegate and a palette creator delegate, forwarding
// calls for picked images to the creator

// Note: Its seems difficult to provide default implementations for objc protocols
// hence we extend a concrete type here instead

class ImagePickerDelegatePaletteCreatorBridge: NSObject, PaletteCreator {
    var controller: PaletteCreatorDelegate?
}

extension ImagePickerDelegatePaletteCreatorBridge: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let
            newImage = info["UIImagePickerControllerOriginalImage"] as? UIImage,
            let path = (info["UIImagePickerControllerReferenceURL"] as? NSURL)?.absoluteString
            else {
                return
        }
        self.controller?.didSelectUserImage(creator:picker, image:newImage, id:path.toBase64())
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true)
    }
}
