//
//  ViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import UIKit

class PaletteDetailViewController: UIViewController, ErrorHandler {

    // MARK: PROPERTIES
    
    // PUBLIC
    var displayIndex = 0
    var delegate: PaletteDetailDelegate?
    var dataSource: PaletteSpecDataSource? {
        didSet{
            dataSource?.observer = self
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
    
    func getCurrentPalette() -> UserOwnedPalette? {
        return dataSource?.getElement(at:displayIndex)
    }
    
    // MARK: TARGET ACTIONS
    
    func toggleFavourite(){
        
        guard let _ = getCurrentPalette() else {
            return
        }
        do {
            try delegate?.didToggleFavourite(index: displayIndex)
        }
        catch{
            showErrorAlert(title: "Error", message: "Please Contact Development...")
        }
    }
    
    // MARK: DISPLAY
    
    func updateViews(){
        guard let _ = viewIfLoaded else {
            return
        }
        guard
            let paletteSpec = getCurrentPalette()
        else {
           return
        }
        paletteView.colors = paletteSpec.colorData
        if paletteSpec.isFavourite == true {
            navigationItem.setRightBarButton(removeFavouriteButton, animated: false)
        }
        else {
            navigationItem.setRightBarButton(addFavouriteButton, animated: false)
        }
    
    }
}

extension PaletteDetailViewController: DataSourceObserver {
    
    func dataDidChange(currentState:DataSourceState){
        
        switch currentState {
            case .furfilled:
            updateViews()
            activityView.stopAnimating()
            
            case .pending:
            activityView.startAnimating()

            default:
            return
        }
    }
}

