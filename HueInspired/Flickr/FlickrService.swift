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
    
    func getLatestInterests(date:Date?, page:Int) -> Promise<Data>
    func getPhoto(_ resource: FlickrPhotoResource) -> Promise<Data>
}

protocol FlickrService {
    
    func getLatestInterests(date:Date?, page:Int) -> Promise<[FlickrPhotoResource]>
    func getPhoto(_ resource: FlickrPhotoResource) -> Promise<FlickrPhoto>

}


// MARK: DATA PROVIDER

struct FlickrServiceProvider: RawFlickrService {
    
    var networkManager: NetworkManager
    var serviceConfig = FlickServiceConfig()
    
    func getLatestInterests(date:Date?=nil, page:Int=1) -> Promise<Data> {
        
        guard page > 0 else {
            fatalError("Invalid Page Number")
        }
        
        let baseUrl = serviceConfig.url(for: FlickrServiceSpec.Path.root.rawValue)

        baseUrl.queryItems = [
                FlickrServiceSpec.Params.method.queryItem(value: FlickrServiceSpec.Methods.interestingness),
                FlickrServiceSpec.Params.api_key.queryItem(value: serviceConfig.Key),
                FlickrServiceSpec.Params.format.queryItem(value: FlickrServiceSpec.Formats.json),
                FlickrServiceSpec.Params.nojsoncallback.queryItem(value: "1"),
                FlickrServiceSpec.Params.per_page.queryItem(value: "10"),
                FlickrServiceSpec.Params.page.queryItem(value:String(page))
        ]
        
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            baseUrl.queryItems?.append(FlickrServiceSpec.Params.date.queryItem(value: dateFormatter.string(from: date)))
        }
        
        // The two possible cases where this is nil
        // is when path component is badly formed. Will never happen
        let url = baseUrl.url!
        
        // FIXME: Inject Level of service
        return networkManager.getData(url, level: .background)
    }
    
    func getPhoto(_ resource: FlickrPhotoResource) -> Promise<Data> {
    
        // FIXME: INJECT LEVEL!
        return networkManager.getData(resource.url, level: DispatchQoS.QoSClass.background)
        
    }
}


// MARK: CLIENT

struct FlickrServiceClient: FlickrService {

    var serviceProvider: RawFlickrService
    
    func getLatestInterests(date:Date?, page:Int=1) -> Promise<[FlickrPhotoResource]> {
        
        let data = serviceProvider.getLatestInterests(date:date, page:page)
        
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
