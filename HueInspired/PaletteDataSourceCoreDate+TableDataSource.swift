//
//  PaletteDataSourceCoreDate+TableDataSource.swift
//  HueInspired
//
//  Created by Ashley Arthur on 12/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


extension CoreDataPaletteDataSource: UITableViewDataSource {
    
    
    // MARK: TABLE DATA
    
    var isLoading: Bool {
        if case DataSourceState.pending = dataState {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if isLoading && section == 0 {
            return 1 // loading cell!
        }
        
        guard let fetchedSections = dataController.sections, section < (fetchedSections.count) else {
            return 0
        }

        let loadingSectionOffset = isLoading ? 1: 0
        return fetchedSections[section - loadingSectionOffset].numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        guard let fetchedSections = dataController.sections else {
            return 0
        }
        
        let loadingSectionOffset = isLoading ? 1: 0
        return fetchedSections.count + loadingSectionOffset
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading && indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "loading")
                else {
                    return UITableViewCell()
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "default") else {
            return UITableViewCell()
        }
        
        guard let sections = dataController.sections,
            indexPath.section < ( sections.count) else {
            return cell
        }
        guard
            let section = dataController.sections?[indexPath.section],
            let palette = section.objects?[indexPath.item] as? UserOwnedPalette
        else {
            return cell
        }
        (cell as! PaletteCell).setDisplay(palette)
        return cell

    }
    
    func configureCell(cell:PaletteCell, palette:UserOwnedPalette) {
        cell.setDisplay(palette)
        //cell.selectionStyle = .none
    }
    
}
