//
//  UIWindow+CustomNotification.swift
//  HueInspired
//
//  Created by Ashley Arthur on 17/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    static let windowDidAssignRootViewController = NSNotification.Name("windowDidAssignRootViewController")
    static let windowAssignRootViewControllerUserInfoKey = "viewController"
    
}
