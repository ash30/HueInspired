//
//  SwatchCollectionCell.swift
//  HueInspired
//
//  Created by Ashley Arthur on 07/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


class SwatchCollectionCell: UICollectionViewCell {
    
    static let defaultReuseIdentifier:String = "SwatchCollectionCell"
    
    var colorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _createSubviews()
    }
    
    func _createSubviews(){
        colorView = UIView()
        contentView.addSubview(colorView!)
        layoutMargins = UIEdgeInsets.zero
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let margins = layoutMarginsGuide
        let constraints = [
            colorView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            colorView.topAnchor.constraint(equalTo: margins.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    

}
