//
//  PaletteCollectionViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 21/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


class PaletteTableViewController : UITableViewController, ErrorHandler{
    
    // MARK: PROPERTIES
    
    // PUBLIC
    var dataSource: ExtendedUITableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource
        }
    }
    
    var delegate: PaletteCollectionDelegate?
    
    // PRIVATE
    fileprivate lazy var tableRefresh = { () -> UIRefreshControl in 
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "Get Latest...")
        control.addTarget(self, action: #selector(syncLatestTarget), for: UIControlEvents.valueChanged)
        return control
    }()

    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        
        // Refresh Control
        self.view.addSubview(tableRefresh)
        
        // Table view config
        tableView.register(PaletteTableCell.self, forCellReuseIdentifier: "default")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "loading")
        tableView.rowHeight = 48
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = .zero

        // Heading
        if let heading = delegate?.collectionTitle {
            tableView.tableHeaderView = {
                let container = UIView()
                let view = UILabel()
                view.text = heading
                view.font = UIFont(name: "Futura", size: 50)
                view.textAlignment = .right
                container.addSubview(view)
                
                // I found no better way than to manually size the frame for now...
                container.frame.size.height = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
                
                view.translatesAutoresizingMaskIntoConstraints = false
                let constraints = [
                    view.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
                    view.topAnchor.constraint(equalTo: container.topAnchor)
                ]
                NSLayoutConstraint.activate(constraints)
                return container
            }()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // kill it as its gets frozen on tab switch
        if tableRefresh.isRefreshing{
            tableRefresh.endRefreshing()
        }
    }
    

    // MARK: TARGET ACTIONS
    
    @objc func syncLatestTarget(){
        tableRefresh.endRefreshing()
        delegate?.didPullRefresh(tableRefresh: tableRefresh)
    }
    
    // MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let ident = segue.identifier else {
            return
        }
        
        // We need to convert table selection to data source index
        // FIXME
        guard
            let selection = tableView.indexPathForSelectedRow,
            let dataSourceIndex = dataSource?.globalIndex(index: selection.item, section: selection.section)
        else {
            return
        }
        
        switch ident {
            
        case "DetailView":
            delegate?.willPresentDetail(viewController: segue.destination, index: dataSourceIndex)
            
        default:
            return
        }
    }
}


// MARK : Data Source Observer

extension PaletteTableViewController: DataSourceObserver {
    
    func dataDidChange(currentState:DataSourceState){
    
        // Edgecase: tab hasn't been displayed yet so table view doesn't exis
        guard let _ = viewIfLoaded else {
            return
        }
        if tableRefresh.isRefreshing {
            tableRefresh.endRefreshing()
        }
        tableView.reloadData()
    }
}
