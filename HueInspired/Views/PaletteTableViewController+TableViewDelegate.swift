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
        guard let _ = dataSource else {
            return
        }
        performSegue(withIdentifier: "DetailView", sender: nil)
        
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
            let title = data.tableView?(tableView, titleForHeaderInSection: section),
            title.characters.count > 1
            else {
                return 0.0
        }
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PaletteCell else {
            return
        }
        cell.label?.isHidden = true
    }
    
}
