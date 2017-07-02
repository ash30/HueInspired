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
    var tableRefresh = UIRefreshControl()
    var searchController = UISearchController(searchResultsController: nil)

    var dataSource: ExtendedUITableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource  // FIXME!
        }
    }
    var delegate: PaletteCollectionDelegate? 
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        
        tableView.register(PaletteTableCell.self, forCellReuseIdentifier: "default")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "loading")

        tableView.rowHeight = 48
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = .zero

        tableRefresh.attributedTitle = NSAttributedString(string: "Get Latest...")
        tableRefresh.addTarget(self, action: #selector(syncLatestTarget), for: UIControlEvents.valueChanged)
        self.view.addSubview(tableRefresh)
        
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
    
    // MARK: TABLE DELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = dataSource else {
            return
        }
        // I don't think  we need to guard on pending updates here,
        // the worst thing that can happen is additional data is available
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
    
        // Edgecase: tab hasn't been displayed yet so table view doesn't exist
        guard let tableView = tableView else {
            return
        }
        
        switch currentState {
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
