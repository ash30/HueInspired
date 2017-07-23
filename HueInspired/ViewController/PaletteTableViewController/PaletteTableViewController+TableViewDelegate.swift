//
//  PaletteTableViewController+TableViewDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 02/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// MARK: TABLE DELEGATE

extension PaletteTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We need to convert table selection to data source index
        guard
            let selection = tableView.indexPathForSelectedRow,
            let palette = dataSource?.getElement(at: selection.item, section: selection.section)
            else {
                return
        }
        
        defer {
            tableView.deselectRow(at: selection, animated:true)
        }
        
        try? delegate?.didSelectPalette(viewController:self, palette:palette)
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 20)
        header.textLabel?.textAlignment = .right
        header.contentView.backgroundColor = tableView.backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard
            let data = dataSource,
            section < data.sections.count
        else {
            return 0.0
        }
        let title = data.sections[section].0
        guard title.characters.count > 1 else {
            return 0.0
        }
        return 30.0
    }

    
}
