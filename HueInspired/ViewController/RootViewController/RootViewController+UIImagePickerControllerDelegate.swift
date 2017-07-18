//
//  RootViewController+UIImagePickerControllerDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 02/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

extension RootViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
