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

// This has to download palettes from a remote service and return a value object

enum RemotePaletteErrors: Error {
    
    case malformedResourceURL
    case malformedResourceData
    case paletteCreationFailure
    
}

protocol PaletteService {
    func getLatest() -> Promise<[ColorPalette]>
}

struct Mock{}

struct RemotePaletteService: PaletteService {
    
    var photoService: FlickrService

    func getLatest() -> Promise<[ColorPalette]> {
        
        return photoService.getLatestInterests().then { (photosResources:[FlickrPhotoResource]) in
            
            let palettes = photosResources.map{ (resource:FlickrPhotoResource) -> Promise<ColorPalette> in
                
                // 2) Convert image to palette on background thread

                let photo = self.photoService.getPhoto(resource)
                
                return photo.then(on: DispatchQueue.global(qos: .background)){(photo:FlickrPhoto) -> Promise<ColorPalette> in
                
                    guard let palette = ImmutablePalette.init(
                        withRepresentativeSwatchesFrom: photo.image, name: photo.description.title, guid:photo.description.id
                    ) else {
                        
                        return Promise(error: RemotePaletteErrors.paletteCreationFailure)
                        
                    }
                    
                    return Promise(value: palette as ColorPalette)
                    
                }
                
            }
            // That should all map quickly as processing is deferred
            
            
            // 4) when all done, return list
            // FIXME: Might be better to stagger this to update incrementally?
            
            return when(resolved: palettes).then { _ in
                return palettes.map {
                    $0.value!
                }
            }
            
        }
    }
    
}
