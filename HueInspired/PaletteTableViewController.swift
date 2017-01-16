//
//  PaletteCollectionViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 21/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


class PaletteTableViewController : UIViewController, UITableViewDataSource {
    
    // MARK: TODO
    internal func refresh() {
        // pass
    }
    
    // MARK: PROPERTIES
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.register(PaletteTableCell.self, forCellReuseIdentifier: "default")
            tableView.rowHeight = 88
            tableView.delegate = self
            tableView.dataSource = self
            tableView.layoutMargins = .zero
        }
    }
    
    var dataSource: PaletteSpecDataSource? {
        didSet{
            dataSource?.observer = self
        }
    }
    var delegate: PaletteCollectionDelegate?
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showPicker))        
        navigationItem.setRightBarButton(createButton, animated: false)
        
    }
    
    // MARK: TABLE DATA
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This should only crash if unregistered!
        let cell = tableView.dequeueReusableCell(withIdentifier: "default")!
        
        guard let data = dataSource?.getElement(at: indexPath.item) else {
            return cell
        }
        
        (cell as? PaletteCell)?.setDisplay(data)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: IMAGE PICKER

extension PaletteTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func showPicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let
            newImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
            else {
                return
        }
        dismiss(animated: true){
            
            // FIXME: REAllY we Want to create a new data source object and segue to it
            // Currently we overwrite the current dataSource Selection 
            
            //self.viewModel?.setSelection( [ImmutablePalette(withRepresentativeSwatchesFrom: newImage, name: nil)!])
            self.performSegue(withIdentifier: "Detail", sender: nil)
        }
        
    }
}

extension PaletteTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.didSelectPalette(viewController: self, index: indexPath.item)
        
    }
    
}

extension PaletteTableViewController: DataSourceObserver {
    
    func dataDidChange() {
        
        // Edgecase: tab hasn't been displayed yet so table view doesn't exist
        guard let tableView = tableView else {
            return
        }
        tableView.reloadData()
    }
    
}
