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
    
    // MARK: INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: LIFE CYCLE
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        resize()
    }
    
    // MARK: HELPER
    
    private func resize(){
        // Resize font and radius
        layer.cornerRadius = layer.frame.width / 2.0
        titleLabel?.font = UIFont.monospacedDigitSystemFont(
            ofSize: layer.frame.width / 2.0,
            weight: UIFontWeightRegular
        )
    }
    
    // MARK: SETUP
    
    private func setup(){
        // Color
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        backgroundColor = UIColor.white
        
        // Shadow
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3.0
        
        // Default Text
        setTitle("+", for: .normal)

        // Font
        setTitleColor(tintColor, for: .normal)
        titleLabel?.textAlignment = .center
        
        resize()
    }
    
    
}
