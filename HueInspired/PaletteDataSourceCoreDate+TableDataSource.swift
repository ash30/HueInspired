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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let fetchedSections = dataController.sections else {
            // No sections, just return count for now...
            switch dataState {
            case .pending:
                return count + 1
            default:
                return count
            }
        }
        guard section < fetchedSections.count else {
            return 0
        }
        return fetchedSections[section].numberOfObjects
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch dataState {
            
        // Display Loading Cell
        case .pending where indexPath.item == 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "loading")
                else {
                    return UITableViewCell()
            }
            return cell
            
        // Display normally but take into acount loading cell offset
        case .pending where indexPath.item > 0:
            guard
                indexPath.item < count + 1,
                let cell = tableView.dequeueReusableCell(withIdentifier: "default")
            else {
                return UITableViewCell()
            }
            configureCell(cell:cell as! PaletteCell, palette: getElement(at: indexPath.item - 1)!)
            return cell
 
            
        // Display normally, map index to datasource
        // FIXME: COPY PASTE
        default:
            guard
                indexPath.item < count,
                let cell = tableView.dequeueReusableCell(withIdentifier: "default")
                else {
                    return UITableViewCell()
            }
            configureCell(cell:cell as! PaletteCell, palette: getElement(at: indexPath.item)!)
            return cell
        }
    }
    
    func configureCell(cell:PaletteCell, palette:UserOwnedPalette) {
        cell.setDisplay(palette)
        //cell.selectionStyle = .none
    }
    
}
