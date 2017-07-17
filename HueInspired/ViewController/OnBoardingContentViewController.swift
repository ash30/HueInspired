//
//  OnBoardingContentViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 17/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import UIKit

class OnBoardingContentViewController: UIViewController {

  
    // MARK: PUBLIC 
    
    var image: UIImage? {
        didSet{
            guard let _ = viewIfLoaded else {
                return
            }
            imageView.image = image
        }
    }
    var blurb: String? {
        didSet{
            guard let _ = viewIfLoaded else {
                return
            }
            textView.text = blurb ?? ""
        }
    }
    
    // MARK: PRIVATE
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func finishOnBoardFlow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: LIFE CYCLE 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update Content
        imageView.image = image
        textView.text = blurb
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
