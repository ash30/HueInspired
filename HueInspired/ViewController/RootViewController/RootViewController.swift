//
//  RootViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 28/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController, PaletteCreator {

    // MARK: PROPERTIES
    
    // PUBLIC
    var controller: PaletteCreatorDelegate?
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    // PRIVATE 
    private lazy var customButton: UIButton! = {
        
        let customButton = TabbarMenuButton()
        self.tabBar.addSubview(customButton)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            customButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            customButton.centerYAnchor.constraint(equalTo: self.tabBar.layoutMarginsGuide.topAnchor),
            customButton.widthAnchor.constraint(equalToConstant: 60),
            customButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
        return customButton
        
    }()
    
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
        //tabBar.backgroundColor = UIColor.white
        imagePicker.delegate = self
        customButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
    }
    
    // MARK: TARGET ACTION
    
    @objc func showPicker() {
        present(imagePicker, animated: true, completion: nil)
    }
}


