//
//  DetailViewDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 10/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol PaletteDetailViewControllerDelegate {
    
    func didToggleFavourite(viewController:PaletteDetailViewController, palette:inout UserOwnedPalette) throws

}

class UserManagedPaletteDetailDelegate: PaletteDetailViewControllerDelegate {
    
    func didToggleFavourite(viewController:PaletteDetailViewController, palette:inout UserOwnedPalette) throws {
        
        palette.isFavourite = !palette.isFavourite
        try viewController.dataSource?.save()
        
    }

}
