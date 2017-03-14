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
    func getLatest() -> Promise<[Promise<ColorPalette>]>
}


class FlickrPaletteSericeAdapter: RemotePaletteService {
    
    var photoService: FlickrService
    
    init(photoService:FlickrService){
        self.photoService = photoService
    }
    
    func getLatest() -> Promise<[Promise<ColorPalette>]> {
        
        return photoService.getLatestInterests().then { (photosResources:[FlickrPhotoResource]) -> [Promise<ColorPalette>] in
            
            return photosResources.map{ (resource:FlickrPhotoResource) -> Promise<ColorPalette> in
                
                let photo = self.photoService.getPhoto(resource)
                
                return photo.then(on:DispatchQueue.global(qos: DispatchQoS.QoSClass.background)){ (photo:FlickrPhoto) -> ColorPalette in
                    
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
