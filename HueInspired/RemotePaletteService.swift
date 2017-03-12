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

enum PaletteErrors: Error {
    
    case paletteCreationFailure
    
}

protocol RemotePaletteService {
    func getLatest() -> Promise<[ColorPalette]>
}


class FlickrPaletteSericeAdapter: RemotePaletteService {
    
    var photoService: FlickrService
    
    init(photoService:FlickrService){
        self.photoService = photoService
    }

    func getLatest() -> Promise<[ColorPalette]> {
        
        return photoService.getLatestInterests().then { (photosResources:[FlickrPhotoResource]) in
            
            let palettes = photosResources.map{ (resource:FlickrPhotoResource) -> Promise<ColorPalette> in
                
                // 2) Convert image to palette on background thread

                let photo = self.photoService.getPhoto(resource)
                
                return photo.then(on: DispatchQueue.global(qos: .background)){(photo:FlickrPhoto) -> Promise<ColorPalette> in
                
                    guard let palette = ImmutablePalette.init(
                        withRepresentativeSwatchesFrom: photo.image, name: photo.description.title, guid:photo.description.id
                    ) else {
                        // Image can't be transformed, just generate a random palette instead.
                        let p = ImmutablePalette.init(namedButWithRandomColors: photo.description.title)
                        return Promise(value: p as ColorPalette)
                        
                    }
                    return Promise(value: palette as ColorPalette)
                    
                }
                
            }

            return when(resolved: palettes).then { _ in

                // If we have too many errors overall, throw error
                // These should either be network errors OR less likely: response parse errors
                let errors = palettes.flatMap{
                    $0.error
                }
                guard errors.count < (palettes.count / 4) else {
                    throw errors.first!
                }
                
                let s = palettes.flatMap{ (p:Promise<ColorPalette>) -> ColorPalette? in
                    p.value
                }
                return Promise(value: s)
            }
            
        }
    }
    
}
