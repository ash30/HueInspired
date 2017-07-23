//
//  ImagePickerDelegate+PaletteCreatorAdapter.swift
//  HueInspired
//
//  Created by Ashley Arthur on 23/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// Helper object that implements image picker delegate and translates call
// to Palette Creator interface as I couldn't find away to implement defaults for
// Objc protocol for the palette creator's. The Palette Creator itself just delegates

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
