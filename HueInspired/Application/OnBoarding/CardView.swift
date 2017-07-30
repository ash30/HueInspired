//
//  CardView.swift
//  HueInspired
//
//  Created by Ashley Arthur on 23/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
    
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
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
    
}
