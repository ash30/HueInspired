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
    var dataSource: UserPaletteDataSource?
    var delegate: PaletteTableViewControllerDelegate?
    
    var currentDisplayState: PaletteTableViewController.DisplayState = .final {
        didSet{
            switch currentDisplayState {
            case .final:
                if (tableRefresh.isRefreshing) {
                    tableRefresh.endRefreshing()
                }
            case .pending:
                // Control should already be spinning
                break
            }
        }
    }
    
    var paletteCollectionName: String = "" {
        didSet{
            if let _ = viewIfLoaded {
                tableViewTitleLabel.text = paletteCollectionName
                tableViewTitleLabel.superview?.frame.size.height = tableViewTitleLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            }
        }
    }
    
    var tableCell: UITableViewCell.Type = PhotoPaletteTableCell.self {
        didSet {
            guard let _ = viewIfLoaded else {
                return
            }
            tableView.register(tableCell, forCellReuseIdentifier: "default")
        }
    }
    
    var tableCellHeight: Float = 150.0 {
        didSet {
            guard let _ = viewIfLoaded else {
                return
            }
            tableView.rowHeight = CGFloat(tableCellHeight)
        }
    }
    
    // PRIVATE
    private lazy var tableRefresh = { () -> UIRefreshControl in
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "Get Latest...")
        control.addTarget(self, action: #selector(syncLatestTarget), for: UIControlEvents.valueChanged)
        return control
    }()
    
    private var tableViewTitleLabel: UILabel!

    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        
        // Refresh Control
        self.view.addSubview(tableRefresh)
        tableView.register(tableCell, forCellReuseIdentifier: "default")
        // Table view config
        tableView.rowHeight = CGFloat(tableCellHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = .zero
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        
        // Heading
        tableView.tableHeaderView = {
            let container = UIView()
            tableViewTitleLabel = UILabel()
            tableViewTitleLabel.text = paletteCollectionName
            tableViewTitleLabel.font = UIFont(name: "Futura", size: 50)
            tableViewTitleLabel.textAlignment = .right
            container.addSubview(tableViewTitleLabel)
            
            // I found no better way than to manually size the frame for now...
            container.frame.size.height = tableViewTitleLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            
            tableViewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                tableViewTitleLabel.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
                tableViewTitleLabel.topAnchor.constraint(equalTo: container.topAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            return container
        }()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // kill it as its gets frozen on tab switch
        currentDisplayState = .final
    }
    

    // MARK: TARGET ACTIONS
    
    @objc func syncLatestTarget(){
        currentDisplayState = .pending
        delegate?.didPullRefresh(viewController: self)
    }
    
    // MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
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
        
        guard let ident = segue.identifier else {
            return
        }
        
        switch ident {
            
        case "DetailView":
            do {
                try delegate?.willPresentDetail(viewController:self, detail:segue.destination as! UserPaletteDetails, palette:palette )
            }
            catch {
                // Error because we failed to create data source...
                report(error: error)
            }
            
        default:
            return
        }
    }
}


// MARK : Data Source Observer

extension PaletteTableViewController: DataSourceObserver {
    
    func dataDidChange(currentState:DataSourceChange){
        // Edgecase: tab hasn't been displayed yet so table view doesn't exist
        guard let _ = viewIfLoaded else {
            return
        }
        switch currentState {
        default:
            tableView.reloadData()
        }
    }
}
