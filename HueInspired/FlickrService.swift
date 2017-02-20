//
//  FlickrService.swift
//  HueInspired
//
//  Created by Ashley Arthur on 19/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit


enum FlickrServiceError: Error {
    
    case malformedRequest
    case malformedResponse
    
}

protocol FlickrService {
    
    func getLatestInterests() throws -> Promise<Data>
}


// MARK: DATA PROVIDER

struct FlickrServiceProvider: FlickrService {
    
    var networkManager: NetworkManager
    var serviceConfig = FlickServiceConfig()
    
    func getLatestInterests() throws -> Promise<Data> {
        
        let baseUrl = serviceConfig.url(for: FlickrServiceSpec.Path.root.rawValue)

        baseUrl.queryItems = [
        
                FlickrServiceSpec.Params.method.queryItem(value: FlickrServiceSpec.Methods.interestingness),
                FlickrServiceSpec.Params.api_key.queryItem(value: serviceConfig.Key),
                FlickrServiceSpec.Params.format.queryItem(value: FlickrServiceSpec.Formats.json)
            
        ]
        
        guard let url = baseUrl.url else {
            throw FlickrServiceError.malformedRequest
        }
        
        // FIXME: Inject Level of service
        return networkManager.getData(url, level: .userInitiated)
        
    }
}


// MARK: CLIENT

struct FlickrServiceClient {

    var serviceProvider: FlickrService
    
    func getLatestInterests() throws -> Promise<[FlickrPhotoResource]> {
        
        let data = try serviceProvider.getLatestInterests()
        
        return data.then { (data:Data) in
            
            guard
                let json = (try? JSONSerialization.jsonObject( with: data, options: .allowFragments)) as? [String:Any],
                let response = json["photos"] as? [String:Any],
                let photos = response["photo"] as? [[String:Any]]
                else {
                    throw FlickrServiceError.malformedResponse
            }
            
            // FIXME: HAS to be a nicer way todo this...
            let refs = photos.map{ return FlickrPhotoResource(jsonResponse: $0)}
            if refs.contains(where: {$0 == nil}) {
                throw FlickrServiceError.malformedResponse
            }
            return Promise(value: refs as! [FlickrPhotoResource])
        }
    }
    
}
