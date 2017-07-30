//
//  PaletteTableViewController+TableViewDataSource.swift
//  HueInspired
//
//  Created by Ashley Arthur on 15/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

extension PaletteTableViewController {
    
    
    // MARK: TABLE DATA
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard
            let dataSource = dataSource,
            section < (dataSource.sections.count )
            else {
                return nil 
        }
        return dataSource.sections[section].0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let dataSource = dataSource,
            section < (dataSource.sections.count )
            else {
                return 0
        }
        return dataSource.sections[section].1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard
            let dataSource = dataSource
            else {
                return 0
        }
        return dataSource.sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO
        guard
            let dataSource = dataSource,
            let cell = tableView.dequeueReusableCell(withIdentifier: "default") else {
            return UITableViewCell()
        }
        
        guard
            indexPath.section < dataSource.sections.count,
            indexPath.item < dataSource.sections[indexPath.section].1,
            let palette = dataSource.getElement(at: indexPath.item, section: indexPath.section)
        else {
            return cell
        }
        
        (cell as! PaletteCell).setDisplay(palette)
        return cell
        
    }
}
