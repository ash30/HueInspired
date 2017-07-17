//
//  ServiceAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject

class ServiceAssembly: Assembly {
    
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
        }
        
    }
 
    
}
