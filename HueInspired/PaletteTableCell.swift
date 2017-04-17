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
    var label: UILabel? { get set }
    func setDisplay(_ palette:ColorPalette)
    
}

extension PaletteCell {
        
    func setDisplay(_ palette:ColorPalette){
        paletteView?.colors = palette.colorData
        label?.text = palette.name
    }
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
    
    override func prepareForReuse(){
        // Make sure we react to possible new orientation
        super.prepareForReuse()
        paletteView?.collectionView.collectionViewLayout.invalidateLayout()
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
                view.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
                view.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
                
                ]
            NSLayoutConstraint.activate(constraints)

            return view
        }()
        
  

    }
    
}
