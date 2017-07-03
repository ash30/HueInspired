//
//  PaletteService.swift
//  HueInspired
//
//  Created by Ashley Arthur on 21/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

// We extend Flickr Client with app specific interface

enum PaletteErrors: Error {
    case paletteCreationFailure
}

protocol RemotePaletteService {
    func getLatest() -> Promise<[Promise<ColorPalette>]>
}

extension FlickrServiceClient: RemotePaletteService {
    
    func getLatest() -> Promise<[Promise<ColorPalette>]> {
        
        return getLatestInterests().then { (photosResources:[FlickrPhotoResource]) -> [Promise<ColorPalette>] in
            
            photosResources.map{ (resource:FlickrPhotoResource) -> Promise<ColorPalette> in
                
                self.getPhoto(resource).then{ (photo:FlickrPhoto) -> ColorPalette in
                    
                    guard let palette = ImmutablePalette.init(
                        withRepresentativeSwatchesFrom: photo.image, name: photo.description.title, guid:photo.description.id
                        ) else {
                            // Image can't be transformed, just generate a random palette instead.
                            let p = ImmutablePalette.init(namedButWithRandomColors: photo.description.title)
                            return p as ColorPalette
                    }
                    return palette as ColorPalette
                }
            }
            
        }
    }
    
    
}

