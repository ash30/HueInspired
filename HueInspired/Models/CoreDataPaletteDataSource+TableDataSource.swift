//
//  PaletteDataSourceCoreDate+TableDataSource.swift
//  HueInspired
//
//  Created by Ashley Arthur on 12/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


protocol ExtendedUITableViewDataSource: UITableViewDataSource {
    
    // flatten index of table index path so clients using just the
    // data source interface can use reference the same item if we
    // are using sections
    func globalIndex(index:Int, section:Int) -> Int?
    
}

extension CoreDataPaletteDataSource: ExtendedUITableViewDataSource {
    func globalIndex(index: Int, section: Int) -> Int? {
        
        guard
            let allSections = dataController.sections,
            section < allSections.count,
            index < allSections[section].numberOfObjects,
            let selection = allSections[section].objects?[index] as? CDSColorPalette,
            let globalList = dataController.fetchedObjects

        else {
            return nil
        }
        return globalList.index(of: selection)
    }
}


extension CoreDataPaletteDataSource: UITableViewDataSource {
    
    
    // MARK: TABLE DATA
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return dataController.sections?[section].name

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let fetchedSections = dataController.sections, section < (fetchedSections.count) else {
            return 0
        }
        return fetchedSections[section].numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
}
