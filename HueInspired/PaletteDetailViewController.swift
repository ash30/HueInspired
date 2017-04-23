//
//  ViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import UIKit

class PaletteDetailViewController: UIViewController, ErrorFeedback {

    // MARK: PROPERTIES
    
    var displayIndex = 0
    
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
    
    lazy var addFavouriteButton: UIBarButtonItem = {
        return UIBarButtonItem(image:#imageLiteral(resourceName: "ic_favorite_border"), style: .plain, target: self, action: #selector(toggleFavourite))
        
        
    }()
    
    lazy var removeFavouriteButton: UIBarButtonItem = {
        return UIBarButtonItem(image:#imageLiteral(resourceName: "ic_favorite"), style: .plain, target: self, action: #selector(toggleFavourite))
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
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

    var delegate: PaletteDetailDelegate?
    var dataSource: PaletteSpecDataSource? {
        didSet{
            dataSource?.observer = self
            //dataDidChange() FIXME:
        }
    }
    
    // MARK: LIFE CYLCE 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        paletteView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // We need this to be able to go back
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true 
    }
    
    // MARK: TARGET ACTIONS
    
    func toggleFavourite(){
        
        guard let p = getSelectedPalette() else {
            return
        }
        
        // Before saving to favourites, make sure palette has a name 
        if p.name == nil {
            let vc = UIAlertController(title: "Save as Favourite", message: nil, preferredStyle: .alert)
            
            vc.addTextField(configurationHandler: { (text:UITextField) in
                text.placeholder = "Palette Name"
            })
            vc.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
                guard let name = vc.textFields?.first?.text else {
                    return
                }
                self.delegate?.didSetNewPaletteName(viewController: self, name: name, index: 0)
                self.toggleFavourites()
            }))
            present(vc, animated: true, completion: nil)
        }
        else {
            toggleFavourites()
        }
    }
    
    // MARK: HELPERS 
    
    func getSelectedPalette() -> UserOwnedPalette? {
        return dataSource?.getElement(at:displayIndex)
    }
    
    func toggleFavourites(){
        // FIXME: FORMALISE 0 INDEX FOR DETAIL VIEW
        do {
            try delegate?.didToggleFavourite(index: displayIndex)
        }
        catch{
            showErrorAlert(title: "Error", message: "Please Contact Development...")
        }
    }
    
    // MARK: DISPLAY
    
    func updateViews(){
        guard
            let paletteSpec = getSelectedPalette()
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

