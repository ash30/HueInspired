//
//  RootViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 28/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import UIKit


class RootViewController: UITabBarController {

    var controller: RootViewControllerDelegate?
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var customButton: UIButton!
    
    // MARK: LIFE CYCLE
    
    override var shouldAutorotate: Bool {
        // Have to disable autorotate after a long battel tryng to get it
        // to work with nested collection views. The optimisations in 'reloadData'
        // meant it wasn't possible to ensure all cells were correctly sized
        // when the orientation callback was called on a child VC
        
        return false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        _setupViews()
        imagePicker.delegate = self
        customButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        
    }
    
    
    func _setupViews(){
        
        let icon = UIImage.init(named: "ic_add_circle")!
        customButton = UIButton()
        customButton.setImage(icon.withRenderingMode(.alwaysTemplate), for: .normal)
        customButton.contentHorizontalAlignment = .fill
        customButton.contentVerticalAlignment = .fill
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.backgroundColor = UIColor.white
        view.addSubview(customButton)
        
        customButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            customButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customButton.centerYAnchor.constraint(equalTo: tabBar.layoutMarginsGuide.topAnchor),
            customButton.widthAnchor.constraint(equalToConstant: 50),
            customButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
        customButton.layer.cornerRadius = 25
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let ident = segue.identifier else {
            return
        }
        
        switch ident {
            
        case "DetailView":
            controller?.willPresentDetail(viewController: segue.destination)
            imagePicker.show(segue.destination, sender: nil)
            
        default:
            return
        }
    }
    
}

// MARK: IMAGE PICKER

extension RootViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func showPicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
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
            
            // IT would be better todo conditional check if we actually changed something
            // Have to do this as merge will be ignored by FRcontroller
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "replace"), object: nil)

        }
    }
}
