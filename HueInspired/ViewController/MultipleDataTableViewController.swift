//
//  MultipleDataTableViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 23/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class MultipleDataTableViewController: UIViewController {

    // MARK: PUBLIC
    var dataSources: [(String,UserPaletteDataSource)] = [] {
        didSet{
            dataSourceSelection = dataSources.first != nil ? 0 : nil
            updateSegmentControl()
        }
    }
    
    func setTableView(_ vc:PaletteTableViewController){
        // Should only really call this once...
        tableView = vc
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        self.tableContainer.addSubview(vc.tableView)
        
        vc.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            vc.tableView.leadingAnchor.constraint(equalTo: self.tableContainer.leadingAnchor),
            vc.tableView.trailingAnchor.constraint(equalTo: self.tableContainer.trailingAnchor),
            vc.tableView.topAnchor.constraint(equalTo: self.tableContainer.topAnchor),
            vc.tableView.bottomAnchor.constraint(equalTo: self.tableContainer.bottomAnchor)
            ])

        updateTable()
    }
    
    var dataSourceSelection:Int? = nil {
        didSet{
            updateTable()
        }
    }
    
    // MARK: PRIVATE
    
    private lazy var rootContainer: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 5.0
        self.view.addSubview(view)
       
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        return view
    }()
    
    private lazy var segmentController: UISegmentedControl = {
        let view = UISegmentedControl()
        view.addTarget(self, action: #selector(updateSelection), for: .valueChanged)
        return view
    }()
    
    private lazy var tableContainer:UIView = {
       return UIView()
    }()
    
    private lazy var tableView: PaletteTableViewController? = nil
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //rootContainer.addArrangedSubview(segmentController)
        navigationItem.titleView = segmentController
        segmentController.autoresizingMask = [.flexibleWidth]
        segmentController.frame = CGRect.init(x: 0, y: 0, width: 200, height: 30)
        rootContainer.addArrangedSubview(tableContainer)
        updateSegmentControl()
    }
    
    // MARK: RENDER
    
    private func updateSegmentControl(){
        guard let _ = viewIfLoaded else {
            return
        }
        segmentController.removeAllSegments()
        for tup in dataSources.enumerated() {
            segmentController.insertSegment(withTitle: tup.element.0, at: tup.offset, animated: false)
        }
        
    }
    
    // MARK: TARGET ACTION
    
    @objc func updateSelection(){
        let index = segmentController.selectedSegmentIndex
        guard index != UISegmentedControlNoSegment else{
            dataSourceSelection = nil
            return
        }
        dataSourceSelection = index
    }
    
    
    private func updateTable(){
        guard
            let index = dataSourceSelection,
            let tableView = tableView
        else {
            return
        }
        guard
            index < dataSources.count
        else {
            fatalError("Segement Selected without backing Datasource") // Should never happen...
        }
        let data = dataSources[index]
        data.1.observer = tableView
        tableView.dataSource = data.1
    }
    
}
