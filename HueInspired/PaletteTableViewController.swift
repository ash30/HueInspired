//
//  PaletteCollectionViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 21/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


class PaletteTableViewController : UIViewController, UITableViewDataSource, PaletteViewController {
    
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
    var tableRefresh = UIRefreshControl()
    
    var dataSource: PaletteSpecDataSource? {
        didSet{
            dataSource?.observer = self
        }
    }
    var delegate: PaletteCollectionDelegate?
    
    
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        dataSource?.syncData()
        
        tableRefresh.attributedTitle = NSAttributedString(string: "Get Latest Trends")
        tableRefresh.addTarget(self, action: #selector(syncLatestTarget), for: UIControlEvents.valueChanged)
        tableView.addSubview(tableRefresh)
        


    }
    
    @objc func syncLatestTarget(){
        delegate?.didPullRefresh(tableRefresh: tableRefresh)
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

// MARK : TABLE DELEGATE

extension PaletteTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.didSelectPalette(viewController: self, index: indexPath.item)
        
    }
    
}

// MARK : Data Source Observer 


extension PaletteTableViewController: DataSourceObserver {
    
    func dataDidChange(error:Error?) {
        
        // Edgecase: tab hasn't been displayed yet so table view doesn't exist
        guard let tableView = tableView else {
            return
        }
        tableView.reloadData()
    }
    
}
