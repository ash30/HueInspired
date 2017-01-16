//
//  PaletteTableCell.swift
//  HueInspired
//
//  Created by Ashley Arthur on 21/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

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


class PaletteTableCell: UITableViewCell, PaletteCell {
    
    var paletteView: PaletteView? {
        
        didSet{
            // We have to do this otherwise we swallow selection events
            paletteView?.isUserInteractionEnabled = false
        }
        
    }
    var label: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _createSubviews()
    }
    
    func _createSubviews(){
       
        let stackView = UIStackView()
        label = UILabel()
        paletteView = PaletteView()
        stackView.addArrangedSubview(label!)
        stackView.addArrangedSubview(paletteView!)
        contentView.addSubview(stackView)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        
        let margins = contentView.layoutMarginsGuide
        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: margins.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
