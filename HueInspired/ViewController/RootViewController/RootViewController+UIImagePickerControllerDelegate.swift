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
            newImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
            else {
                return
        }
        self.controller?.didSelectUserImage(viewController:imagePicker, image: newImage)
        performSegue(withIdentifier: "DetailView", sender: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true){
            
        }
    }
}
