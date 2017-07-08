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
    var delegate: PaletteDetailDelegate?
    var dataSource: Promise<UserPaletteDataSource>? {
        didSet{
            _ = self.dataSource?.then { [weak self] in
                $0.observer = self
            }
            updateViews()
        }
    }
    
    // PRIVATE
    
    @IBOutlet weak fileprivate var stackView: UIStackView! {
        didSet{
            stackView.layoutMargins = UIEdgeInsets.zero
        }
    }
    @IBOutlet weak fileprivate var paletteView: PaletteView! {
        didSet{
            paletteView.direction = .vertical
            paletteView.hideLabels = false 
            paletteView.layoutMargins =  UIEdgeInsets.zero
        }
    }
    
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
        // We need this to be able to go back
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        // sync render state with current data source
        updateViews()
        
    }
    
    // MARK: HELPERS
    
    private func getCurrentPalette() -> UserOwnedPalette? {
        return dataSource?.value?.getElement(at:displayIndex)
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
        guard let dataSource = dataSource else {
            return // no data to render
        }
        guard let _ = viewIfLoaded else {
            return // no views to update
        }

        if (dataSource.isPending && (!activityView.isAnimating)){
            activityView.startAnimating()
        }

        dataSource.then { [weak self] _ -> () in
            // We may exit vc before being fulfilled, so weakly reference self
            guard let vc = self else {
                return
            }
            
            // Update Views to match given Palette
            guard
                let palette = vc.getCurrentPalette()
            else {
                fatalError("DetailView rendering empty datasource")
            }
            vc.paletteView.colors = palette.colorData
            if palette.isFavourite == true {
                vc.navigationItem.setRightBarButton(vc.removeFavouriteButton, animated: false)
            }
            else {
                vc.navigationItem.setRightBarButton(vc.addFavouriteButton, animated: false)
            }
        }
        .always{ [weak self] _ -> () in
            guard let vc = self else {
                return
            }
            vc.activityView.stopAnimating()

        } 
    }
}

extension PaletteDetailViewController: DataSourceObserver {
    
    func dataDidChange(currentState:DataSourceState){
        updateViews()
    }
}

