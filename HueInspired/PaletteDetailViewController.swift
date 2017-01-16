//
//  ViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import UIKit

class PaletteDetailViewController: UIViewController {

    // MARK: PROPERTIES
    
    @IBOutlet weak var stackView: UIStackView! {
        didSet{
            stackView.layoutMargins = UIEdgeInsets.zero
        }
    }
    @IBOutlet weak var paletteView: PaletteView! {
        didSet{
            paletteView.direction = .vertical
            paletteView.layoutMargins =  UIEdgeInsets.zero
        }
    }
    
    lazy var favouriteButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(toggleFavourite)
        )
    }()
    
    var delegate: PaletteCollectionController?
    var dataSource: PaletteSpecDataSource? {
        didSet{
            dataSource?.observer = self
        }
    }
    
    // MARK: LIFE CYLCE 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(favouriteButton, animated: false)
        updateViews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        paletteView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: TARGET ACTIONS
    
    func toggleFavourite(){
        
        // FIXME: FORMALISE 0 INDEX FOR DETAIL VIEW
        delegate?.didToggleFavourite(viewController: self, index: 0)
    }
    
    // MARK: DISPLAY
    
    func updateViews(){
        guard
            let dataSource = dataSource,
            let paletteSpec = dataSource.getElement(at:0) //FIXME: HOW DO WE KNOW WHAT ELEMENT?
        else {
           return
        }
        paletteView.colors = paletteSpec.colorData
        if paletteSpec.isFavourite == true {
            favouriteButton.style = .done
        }
        else {
            favouriteButton.style = .plain
        }
    
    }
}

extension PaletteDetailViewController: DataSourceObserver {
    func dataDidChange() {
        updateViews()
    }
}

