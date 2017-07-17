//
//  PhotoPaletteViewTableCell.swift
//  HueInspired
//
//  Created by Ashley Arthur on 17/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class PhotoPaletteTableCell: UITableViewCell, PaletteCell {
    
    var paletteView: PaletteView?
    var paletteImageView: UIImageView?
    
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
        paletteImageView?.image = palette.image
    }
    
    func _createSubviews(){
        

        let container = { () -> UIStackView in
            
            let parent = UIView()
            parent.layer.cornerRadius = 5.0
            parent.layer.masksToBounds = true
            
            self.contentView.addSubview(parent)
            parent.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate( [
                parent.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
                parent.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
                parent.centerYAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.centerYAnchor),
                parent.heightAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.heightAnchor)
            ])
            
            // ----------------------
            
            let view = UIStackView()
            parent.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate( [
                view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                view.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
                view.heightAnchor.constraint(equalTo: parent.heightAnchor)
            ])
            
            return view
        }()
        
        paletteImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            container.addArrangedSubview(view)
            
            let constraints = [
                view.heightAnchor.constraint(equalTo: view.widthAnchor),
                view.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33 )
            ]
            NSLayoutConstraint.activate(constraints)
            return view
        }()
        
        paletteView = {
            let view  = PaletteView()
            view.isUserInteractionEnabled = false
            view.translatesAutoresizingMaskIntoConstraints = false
            container.addArrangedSubview(view)
            return view
        }()
        
        
        
    }
    
}
