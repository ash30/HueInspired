//
//  PaletteView.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class PaletteView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: PROPERTIES
    
    var hideLabels = true
    
    var colors: [DiscreteRGBAColor] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var direction: UICollectionViewScrollDirection = .horizontal {
        didSet{
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.scrollDirection = direction
            collectionView.reloadData()
        }
    }
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        
        collectionView.register(
            SwatchCollectionCell.self,
            forCellWithReuseIdentifier: SwatchCollectionCell.defaultReuseIdentifier
        )
        //collectionView.layoutMargins = UIEdgeInsets.zero
        collectionView.backgroundColor = UIColor.black
        
        return collectionView
    }()
    
    // MARK: INIT
    
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
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        layoutMargins =  UIEdgeInsets.zero

        // LAYOUT
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let margins = layoutMarginsGuide
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: margins.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }


    // MARK: FLOW LAYOUT DELEGATE
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let parentViewSize = collectionView.frame
        let nummberOfItems = self.collectionView(collectionView, numberOfItemsInSection:0)
        
        /*  we have to be careful to remember truncated values else we'll have little black borders
            between the cells. We size the first cell slightly bigger to remove all the gaps
        */
        let dimension = direction == .horizontal ? parentViewSize.width : parentViewSize.height
        let unitSize = Int(dimension / CGFloat(nummberOfItems))
        let finalSize = indexPath.item > 0 ? CGFloat(unitSize) : dimension - CGFloat(unitSize * (nummberOfItems - 1))
        
        switch direction {
            
        case .horizontal:
            return CGSize(width: finalSize, height: parentViewSize.height)
        case .vertical:
            return CGSize(width: parentViewSize.width, height: finalSize)
            
        }
    }

    // MARK: COLLECTION DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwatchCollectionCell.defaultReuseIdentifier, for: indexPath) as! SwatchCollectionCell
        
        guard indexPath.item < colors.count else {
            return cell
        }
        
        cell.setDisplayColor(color: colors[indexPath.item].uiColor, updateLabel:!hideLabels)
        cell.label.isHidden = hideLabels
        return cell
        
    }
}
