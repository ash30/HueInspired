//
//  LoadingCell.swift
//  HueInspired
//
//  Created by Ashley Arthur on 13/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class LoadingCell: UITableViewCell {
    

    var activityView: UIActivityIndicatorView!
    var label: UILabel!
    
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
        activityView.startAnimating()
    }
    
    func _createSubviews(){
        activityView = UIActivityIndicatorView()
        self.contentView.addSubview(activityView)
        activityView.startAnimating()
        activityView.color = self.tintColor
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            activityView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
}
