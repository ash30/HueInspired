//
//  ViewControllerDelegates.swift
//  HueInspired
//
//  Created by Ashley Arthur on 07/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import PromiseKit

protocol PaletteTableViewControllerDelegate {
    
    func didPullRefresh(viewController:PaletteTableViewController)
    func willPresentDetail(viewController:PaletteTableViewController, detail:UIViewController, index:Int )
    
}

extension PaletteTableViewControllerDelegate {
    
    func didPullRefresh(viewController:PaletteTableViewController){
        // Default is do nothing and set state back to stop spinner
        viewController.currentDisplayState = .final
    }
    
    func willPresentDetail(viewController:PaletteTableViewController, detail:UIViewController, index:Int ){
    }
}
