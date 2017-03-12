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
    
    // MARK: TODO
    internal func refresh() {
        // pass
    }
    
    // MARK: PROPERTIES
    var tableRefresh = UIRefreshControl()
    var searchController = UISearchController(searchResultsController: nil)

    var dataSource: PaletteSpecDataSource? {
        didSet{
            dataSource?.observer = self
        }
    }
    var delegate: PaletteCollectionDelegate? {
        didSet{
            dataSource = delegate?.getDataSource()
            dataSource?.syncData()
        }
    }
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        
        tableView.register(PaletteTableCell.self, forCellReuseIdentifier: "default")
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

        
        //delegate?.didLoad(viewController:self)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        // kill it as its gets frozen on tab switch
        if tableRefresh.isRefreshing{
            tableRefresh.endRefreshing()
        }
    }
    

    
    // MARK: TARGET ACTIONS
    
    @objc func syncLatestTarget(){
        delegate?.didPullRefresh(tableRefresh: tableRefresh)
    }
    
    // MARK: TABLE DATA
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "default"),
            let data = dataSource?.getElement(at: indexPath.item)
            else {
                return UITableViewCell()
        }
        
        (cell as? PaletteCell)?.setDisplay(data)
        cell.selectionStyle = .none
        return cell
    }

    // MARK: TABLE DELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.didSelectPalette(viewController: self, index: indexPath.item)
        
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
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        dataSource?.clearFilter()
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
            break
            
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
