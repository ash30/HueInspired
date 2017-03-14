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
    
    lazy var addFavouriteButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(toggleFavourite)
        )
    }()
    
    lazy var removeFavouriteButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(toggleFavourite)
        )
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
            dataDidChange()
        }
    }
    
    // MARK: LIFE CYLCE 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource?.syncData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        paletteView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: TARGET ACTIONS
    
    func toggleFavourite(){
        
        guard let p = dataSource?.getElement(at:0) else {
            return
        }
        
        if p.name == nil {
            
            let vc = UIAlertController(title: "Save as Favourite", message: nil, preferredStyle: .alert)
            
            vc.addTextField(configurationHandler: { (text:UITextField) in
                text.placeholder = "Palette Name"
            })
            vc.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
                guard let name = vc.textFields?.first?.text else {
                    return
                }
                // FIXME: FORMALISE 0 INDEX FOR DETAIL VIEW
                self.delegate?.didSetNewPaletteName(viewController: self, name: name, index: 0)
                self.delegate?.didToggleFavourite(viewController: self, index: 0)
            }))
            
            present(vc, animated: true, completion: nil)
        }
        else {
            // FIXME: FORMALISE 0 INDEX FOR DETAIL VIEW
            delegate?.didToggleFavourite(viewController: self, index: 0)
        }
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
            navigationItem.setRightBarButton(removeFavouriteButton, animated: false)
        }
        else {
            navigationItem.setRightBarButton(addFavouriteButton, animated: false)
        }
    
    }
}

extension PaletteDetailViewController: DataSourceObserver {
    
    func dataDidChange() {
        guard let state = dataSource?.dataState else {
            return
        }
        
        switch state {
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

