  //
//  ViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import UIKit
import PromiseKit


class PaletteDetailViewController: UIViewController, ErrorHandler {

    // MARK: PROPERTIES
    
    // PUBLIC
    var displayIndex = 0
    var delegate: PaletteDetailViewControllerDelegate?
    var dataSource:UserPaletteDataSource? {
        didSet{
            if let dataSource = dataSource {
                dataSource.observer = self
            }
            updateViews()
        }
    }
    
    // PRIVATE
    
    lazy fileprivate var paletteView: PaletteView! = {
        let view = PaletteView.init(frame: self.view.frame)
        self.view.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        view.direction = .vertical
        view.hideLabels = false
        view.layoutMargins =  UIEdgeInsets.zero
        
        return view
    }()
    
    private lazy var addFavouriteButton: UIBarButtonItem = {
        return UIBarButtonItem(image:#imageLiteral(resourceName: "ic_favorite_border"), style: .plain, target: self, action: #selector(toggleFavourite))
    }()
    
    private lazy var removeFavouriteButton: UIBarButtonItem = {
        return UIBarButtonItem(image:#imageLiteral(resourceName: "ic_favorite"), style: .plain, target: self, action: #selector(toggleFavourite))
    }()
    
    fileprivate lazy var activityView: UIActivityIndicatorView = {
        
        let activityView = UIActivityIndicatorView()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.startAnimating()
        self.view.addSubview(activityView)

        let constraints = [
            activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        return activityView
    }()
    
    // MARK: LIFE CYLCE 
    
    override func viewWillAppear(_ animated: Bool) {
        // Need to call asap incase we have to start activity view
        updateViews()
    }
    
    // MARK: HELPERS
    
    private func getCurrentPalette() -> UserOwnedPalette? {
        // TODO: FIX HARDCODED SECTION
        return dataSource?.getElement(at:displayIndex, section:0)
    }
    
    // MARK: TARGET ACTIONS
    
    @objc func toggleFavourite(){
        
        guard let palette = getCurrentPalette() else {
            return
        }
        do {
            try delegate?.didToggleFavourite(viewController:self, palette:palette)
        }
        catch{
            showErrorAlert(title: "Error", message: "Please Contact Development...")
        }
    }
    
    // MARK: DISPLAY
    
    fileprivate func updateViews(){
        guard let _ = viewIfLoaded else {
            return // no views to update
        }

        if (dataSource == nil && (!activityView.isAnimating)){
            activityView.startAnimating()
            return
        }

        if let dataSource = dataSource {
            // Update Views to match given Palette
            guard
                let palette = getCurrentPalette()
                else {
                    fatalError("DetailViewController datasource doesn't respect displayIndex")
            }
            paletteView.colors = palette.colorData
            if palette.isFavourite == true {
                navigationItem.setRightBarButton(removeFavouriteButton, animated: false)
            }
            else {
                navigationItem.setRightBarButton(addFavouriteButton, animated: false)
            }
        }

    }
}

extension PaletteDetailViewController: DataSourceObserver {
    
    func dataDidChange(currentState:DataSourceChange){
        updateViews()
    }
}

