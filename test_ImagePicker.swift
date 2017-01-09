//
//  testImagePicker.swift
//  HueInspired
//
//  Created by Ashley Arthur on 08/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerViewController: UIViewController  {

    var selectedImage: UIImage?
    var imagePicker = UIImagePickerController() {
        didSet{
        }
    }
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary


    }
    
    @IBAction func pickImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let ident = segue.identifier else {
            return
        }
        switch ident {
            
            case "ShowPalette":
                if let image = selectedImage {
                    let vc = segue.destination as! PaletteDetailViewController
                    vc.display(image)
                }
            default:
                print("BAD SEGUE")
        }
        
    }
    
}

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("here")
        guard let
            newImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
            else {
                return
        }
        dismiss(animated: true, completion: nil)
        selectedImage = newImage
        performSegue(withIdentifier: "ShowPalette", sender: nil)
        
    }
    
}
