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
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _createSubviews()
    }
    
    func setDisplayColor(color:UIColor, updateLabel:Bool=true){
        colorView.backgroundColor = color
        
        guard updateLabel == true else {
            return
        }
        
        var R:CGFloat=0.0, G:CGFloat=0.0, B:CGFloat=0.0
        var H:CGFloat=0.0, S: CGFloat=0.0, V:CGFloat=0.0
        
        guard color.getRed(&R, green: &G, blue: &B, alpha: nil) == true else {
            return
        }
        label.text = "R:\(NSString(format: "%.3f", R)), G:\(NSString(format: "%.3f", G)), B:\(NSString(format: "%.3f", B))"
        
        guard color.getHue(&H, saturation: &S, brightness: &V, alpha: nil) == true else {
            return
        }
        
        label.textColor = UIColor.init(
            hue: H,
            saturation: 0.5,
            brightness: V > 0.5 ? 0.15 : 0.9,
            alpha: 1.0
        )
        
    }
    
    func _createSubviews(){
        
        contentView.clipsToBounds = true
        
        colorView = {
            let view = UIView()
            contentView.addSubview(view)
            layoutMargins = UIEdgeInsets.zero
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let margins = self.layoutMarginsGuide
            let constraints = [
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                view.topAnchor.constraint(equalTo: margins.topAnchor),
                view.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ]
            NSLayoutConstraint.activate(constraints)
            return view
        }()
        
        label = {
            let view = UILabel()
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            let margins = self.layoutMarginsGuide
            let constraints = [
                //view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.topAnchor.constraint(equalTo: margins.topAnchor),
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant:8.0),

            ]
            NSLayoutConstraint.activate(constraints)
            view.text = "TEST"
            return view
        }()
        

        
    }
    

}
