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
        
    func didPullRefresh() -> Promise<Bool>
    func didSelectPalette(viewController:UIViewController, palette:UserOwnedPalette) throws
    
}

enum PaletteTableViewControllerDelegateError: Error {

    case dataSourceCreationFail
    
}
