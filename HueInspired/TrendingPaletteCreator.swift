//
//  PaletteCreatorTableDelegate.swift
//  HueInspired
//
//  Created by Ashley Arthur on 28/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


class TrendingPaletteCreator: NSObject {
    var creator: PaletteCreator?
    
    var factory: ColorPaletteDataSourceFactory
    var imageService: FlickrTrendingPhotoService
    
    init(factory: @escaping ColorPaletteDataSourceFactory, imageService: FlickrTrendingPhotoService){
        self.factory = factory
        self.imageService = imageService
    }
    
}

extension TrendingPaletteCreator: PaletteTableViewControllerDelegate {
    
    func didPullRefresh(viewController:PaletteTableViewController) {
        
        guard let creator = creator else {
            viewController.currentDisplayState = .final
            return
        }
        
        _ = imageService.next()
        
        .then {
            creator.createFrom(image: $0.image, id: $0.description.id)
        }
            
        .then { [weak self] (p:ColorPalette) -> (UserPaletteDataSource) in
            guard
                let _self = self,
                let dataSource = _self.factory(p) else {
                    throw PaletteErrors.paletteCreationFailure
            }
            return dataSource
        }
            
        .then {
            try $0.save()
        }
            
        .catch { (error:Error) in
            viewController.report(error: error)
        }
        .always {
            viewController.currentDisplayState = .final
        }
        
        
    }
    
    // NOT IMPLEMENTED
    
    func didSelectPalette(viewController:PaletteTableViewController, palette:UserOwnedPalette) throws {
        return
    }
    
}
