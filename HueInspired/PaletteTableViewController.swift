//
//  PaletteCollectionViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 21/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


class PaletteTableViewController : UITableViewController, ErrorFeedback{
    
    // MARK: PROPERTIES
    var tableRefresh = UIRefreshControl()
    var searchController = UISearchController(searchResultsController: nil)

    var dataSource: PaletteSpecDataSource? {
        didSet{
            dataSource?.observer = self
            tableView.dataSource = dataSource as? UITableViewDataSource // FIXME!
            dataSource?.syncData()            
        }
    }
    var delegate: PaletteCollectionDelegate? 
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        
        tableView.register(PaletteTableCell.self, forCellReuseIdentifier: "default")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "loading")

        tableView.rowHeight = 88
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = .zero

        tableRefresh.attributedTitle = NSAttributedString(string: "Get Latest...")
        tableRefresh.addTarget(self, action: #selector(syncLatestTarget), for: UIControlEvents.valueChanged)
        self.view.addSubview(tableRefresh)
        
        tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false 

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
    
    // MARK: TABLE DELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = dataSource else {
            return
        }
        
        switch data.dataState {
        case .pending:
            return // disallow if currently pending
        default:
            performSegue(withIdentifier: "DetailView", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let ident = segue.identifier else {
            return
        }
        
        switch ident {
            
        case "DetailView":
            delegate?.willPresentDetail(viewController: segue.destination, index: tableView.indexPathForSelectedRow!.item)
            
        default:
            return
        }
    }
    
    
}

// MARK : SEARCH DELEGATE

extension PaletteTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        guard
            let text =  searchBar.text,
            text.characters.count > 0
            else {
                dataSource?.clearFilter()
                return
        }
        dataSource?.filterData(by:text)
        dataSource?.syncData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        dataSource?.clearFilter()
        dataSource?.syncData()
    }
}


// MARK : Data Source Observer


extension PaletteTableViewController: DataSourceObserver {
    
    func dataDidChange() {
        
        // Edgecase: tab hasn't been displayed yet so table view doesn't exist
        guard let tableView = tableView else {
            return
        }
        guard let state = dataSource?.dataState else {
            return
        }
        
        switch state {
        case .furfilled:
            if tableRefresh.isRefreshing {
                tableRefresh.endRefreshing()
            }
            tableView.reloadData()
            
        case .pending:
            tableView.reloadData()
            
        case .errored(let error):
            tableRefresh.endRefreshing()
            
            switch error {
            case is FlickrServiceError:
                showErrorAlert(title: "Service Error", message: "Please Report this to the developer")
            case is HTTPClient.NetworkError:
                showErrorAlert(title: "Network Error", message: "Can't reach the Server , Please Try again later")
            default:
                showErrorAlert(title: "Network Error", message: "Can't Connect to the network , Please Try again later")
            }
            
        default:
            return
        }    }
    
}
