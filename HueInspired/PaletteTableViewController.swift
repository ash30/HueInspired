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
            dataDidChange()
        }
    }
    var delegate: PaletteCollectionDelegate? {
        didSet{
            dataSource = delegate?.getDataSource()
            delegate?.didLoad(viewController:self)
        }
    }
    
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
    
    // MARK: TABLE DATA
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let data = dataSource else {
            return 0
        }
        
        switch data.dataState {
        case .pending:
            return data.count + 1
        default:
            return data.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let data = dataSource else {
            return UITableViewCell()
        }
        
        switch data.dataState {
        case .pending where indexPath.item == 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "loading")
            else {
                return UITableViewCell()
            }
            return cell
        case .pending where indexPath.item > 0:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "default"),
                let data = dataSource?.getElement(at: indexPath.item - 1)
                else {
                    return UITableViewCell()
            }
            (cell as? PaletteCell)?.setDisplay(data)
            cell.selectionStyle = .none
            return cell
        default:
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
            delegate?.didSelectPalette(viewController: self, index: indexPath.item)
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
