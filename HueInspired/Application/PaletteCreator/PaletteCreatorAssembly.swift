//
//  ServiceAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import UIKit

typealias PaletteCreationMenuViewController = UIAlertController
typealias StandaloneActivityController = UIAlertController

class PaletteCreatorAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: NETWORK SERVICES
        
        container.register(FlickrTrendingPhotoService.self){ r in
            
            let neworkManager: NetworkManager = r.resolve(NetworkManager.self)!
            let photoService = FlickrServiceClient(
                serviceProvider: FlickrServiceProvider(
                    networkManager: neworkManager , serviceConfig: FlickServiceConfig()
                )
            )
            let service = FlickrTrendingPhotoService.init(photoService:photoService, preferences:r.resolve(PreferenceRegistry.self)!)
            service.resume()
            return service
            
        }.inObjectScope(.container)
        
        // MARK: CONTROLLERS
        
        container.register(UserImagePaletteCreator.self) { r in
            let controller = UserImagePaletteCreator(factory: r.resolve(ColorPaletteDataSourceFactory.self, name:"Temp")!)
            controller.creator = DominantColorPaletteCreator()
            return controller
            
        }
        
        container.register(TrendingPaletteCreator.self) { r in
            let controller = TrendingPaletteCreator(
                factory: r.resolve(ColorPaletteDataSourceFactory.self,name:"Temp")!,
                imageService: r.resolve(FlickrTrendingPhotoService.self)!
            )
            controller.creator = DominantColorPaletteCreator()
            return controller
        }
        
        // MARK: VIEWS
        
        container.register(PaletteCreationMenuViewController.self) { (r, presenter:UIViewController) in
            let vc = UIAlertController(title: "Choose Source of Inspiration:", message: nil, preferredStyle: .actionSheet)
            let paletteCreator = r.resolve(UserImagePaletteCreator.self)!
            let imagePicker = UIImagePickerController()
            let trendingPaletteCreator = r.resolve(TrendingPaletteCreator.self)!

            // Create from image
            let createUserPalette = UIAlertAction(title: "Photo Gallery", style: .default){ _ in
                imagePicker.delegate = paletteCreator
                presenter.present(imagePicker, animated: true)
            }
            vc.addAction(createUserPalette)
            
            // Create from Flickr
            let TrendingPalette = UIAlertAction(title: "Trending Photos", style: .default){ _ in
                
                let loadingScreen = r.resolve(StandaloneActivityController.self)!
                _ = trendingPaletteCreator.didPullRefresh().always { [weak loadingScreen] _ in
                    presenter.dismiss(animated: true)
                }
                presenter.present(loadingScreen, animated: true)

            }
            vc.addAction(TrendingPalette)

            let cancel = UIAlertAction(title: "Cancel", style: .cancel){ [weak vc] _ in
                vc?.dismiss(animated: true)
            }
            vc.addAction(cancel)

            return vc
        }
        
        // TODO: Better Loading screen
        container.register(StandaloneActivityController.self) { r in
            return UIAlertController(title: "Creating Palette", message: nil, preferredStyle: .alert)

        }
        
    }
 
    
}
