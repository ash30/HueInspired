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
    var dataSource: Promise<UserPaletteDataSource>? {
        didSet{
            _ = self.dataSource?.then { [weak self] (data:UserPaletteDataSource) -> () in
                data.observer = self
                self?.updateViews()
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
        
        // Need to call asap incase we have to start activity view
        updateViews()
        
    }
    
    // MARK: HELPERS
    
    private func getCurrentPalette() -> UserOwnedPalette? {
        // TODO: FIX HARDCODED SECTION
        return dataSource?.value?.getElement(at:displayIndex, section:0)
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
            
            dataSource.catch { [weak self] _ in
                // This could happen due to dodgy input image provided by user so we
                // so we gracefully warn user
                self?.showErrorAlert(title: "Error", message: "Unable to create Palette")
            }
            .always{ [weak self] _ -> () in
                guard let vc = self else {
                    return
                }
                vc.activityView.stopAnimating()
            }
        }
        
        // Its easier if we test for fulfilment instead of using 'then' here
        // as it keeps drawing code serial. Then'ing on a already resolved
        // promise still asyncs the callback (rightly!) which slightly
        // complicates the tests
        
        if dataSource.isFulfilled {
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

