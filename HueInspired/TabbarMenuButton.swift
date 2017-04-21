//
//  Highlightbutton.swift
//  HueInspired
//
//  Created by Ashley Arthur on 21/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? tintColor : UIColor.white
        }
    }
    
}

class TabbarMenuButton: CustomButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: SETUP
    
    func setup(){
        // MARK: Appearance
        layer.cornerRadius = 30
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        backgroundColor = UIColor.white
        
        setTitle("+", for: .normal)
        setTitleColor(tintColor, for: .normal)
        titleLabel?.font = UIFont.monospacedDigitSystemFont(
            ofSize: 30.0,
            weight: UIFontWeightRegular)
        titleLabel?.textAlignment = .center
    }
    
    
}
