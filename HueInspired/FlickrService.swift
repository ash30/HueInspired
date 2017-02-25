//
//  FlickrService.swift
//  HueInspired
//
//  Created by Ashley Arthur on 19/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit

enum FlickrServiceError: Error {
    
    case malformedRequest
    case malformedResponse
    case malformedImageData
    
}

protocol RawFlickrService {
    
    func getLatestInterests() -> Promise<Data>
    func getPhoto(_ resource: FlickrPhotoResource) -> Promise<Data>
}

protocol FlickrService {
    
    func getLatestInterests() -> Promise<[FlickrPhotoResource]>
    func getPhoto(_ resource: FlickrPhotoResource) -> Promise<FlickrPhoto>

}


// MARK: DATA PROVIDER

struct FlickrServiceProvider: RawFlickrService {
    
    var networkManager: NetworkManager
    var serviceConfig = FlickServiceConfig()
    
    func getLatestInterests() -> Promise<Data> {
        
        let baseUrl = serviceConfig.url(for: FlickrServiceSpec.Path.root.rawValue)

        baseUrl.queryItems = [
        
                FlickrServiceSpec.Params.method.queryItem(value: FlickrServiceSpec.Methods.interestingness),
                FlickrServiceSpec.Params.api_key.queryItem(value: serviceConfig.Key),
                FlickrServiceSpec.Params.format.queryItem(value: FlickrServiceSpec.Formats.json)
    
        ]

        // The two possible cases where this is nil
        // is when path component is badly formed. Will never happen
        let url = baseUrl.url!
        
        // FIXME: Inject Level of service
        return networkManager.getData(url, level: .userInitiated)
    }
    
    func getPhoto(_ resource: FlickrPhotoResource) -> Promise<Data> {
    
        // FIXME: INJECT LEVEL!
        return networkManager.getData(resource.url, level: DispatchQoS.QoSClass.default)
        
    }
}


// MARK: CLIENT

struct FlickrServiceClient: FlickrService {

    var serviceProvider: RawFlickrService
    
    func getLatestInterests() -> Promise<[FlickrPhotoResource]> {
        
        let data = serviceProvider.getLatestInterests()
        
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
    
    func getPhoto(_ resource: FlickrPhotoResource) -> Promise<FlickrPhoto> {
        
        // FIXME: INJECT LEVEL!
        
        return serviceProvider.getPhoto(resource).then { (data:Data) in
            guard let image = UIImage.init(data: data) else {
                return Promise(error: FlickrServiceError.malformedImageData )
            }
            return Promise(value: FlickrPhoto(description: resource, image: image))
        }
        
    }
    
}
