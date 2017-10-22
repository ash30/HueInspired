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
            updateDisplay()
        }
    }
    var blurb: String? {
        didSet{
            updateDisplay()
        }
    }
    var cardTitle: String? {
        didSet{
            updateDisplay()
        }
    }
    
    // MARK: PRIVATE
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView! {
        didSet{
            textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
        }
    }
    
    @IBOutlet weak var titleView: UILabel! {
        didSet{
            titleView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        }
    }
        
    // MARK: LIFE CYCLE 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update Content
        updateDisplay()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateDisplay(){
        guard let _ = viewIfLoaded else {
            return
        }
        imageView.image = image
        titleView.text = cardTitle ?? ""
        textView.text = blurb ?? ""
    }


}
