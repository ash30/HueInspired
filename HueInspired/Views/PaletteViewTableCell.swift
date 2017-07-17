//
//  PaletteTableCell.swift
//  HueInspired
//
//  Created by Ashley Arthur on 21/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// MARK: INTERFACE

protocol PaletteCell {
    
    var paletteView: PaletteView? { get set }
    func setDisplay(_ palette:ColorPalette)
    
}

// MARK: IMPLEMENTATION

class PaletteTableCell: UITableViewCell, PaletteCell {
    
    var paletteView: PaletteView?
    var label: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _createSubviews()
    }
    
    func setDisplay(_ palette:ColorPalette){
        paletteView?.colors = palette.colorData
    }
    
    func _createSubviews(){
       
        label = UILabel()
        paletteView = {
            let view  = PaletteView()
            view.layer.cornerRadius = 5.0
            view.layer.masksToBounds = true
            view.isUserInteractionEnabled = false
            self.contentView.addSubview(view)
            
            self.contentView.preservesSuperviewLayoutMargins = false
            let margins = self.contentView.layoutMarginsGuide
            view.translatesAutoresizingMaskIntoConstraints = false

            
            
            let constraints = [
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                view.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
                view.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
            ]
            NSLayoutConstraint.activate(constraints)

            return view
        }()
        
  

    }
    
}
