//
//  FlickrServiceSpec.swift
//  HueInspired
//
//  Created by Ashley Arthur on 19/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

// MARK: SERVICE CONFIG
// server settings need to interact with service

struct FlickServiceConfig {
    let scheme : String = "https"
    let host: String = "api.flickr.com"
    let Key: String = "21d84efb405c7ff44a32210f66514819"
}

extension FlickServiceConfig {
    
    func url(for path:String) -> NSURLComponents {
        let components = NSURLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        return components
    }
    
}

// MARK: SERVICE SPEC
// an outline of the methods we can call

struct FlickrServiceSpec {
    enum Params: String {
        case method
        case api_key
        case format
        case nojsoncallback
        case auth_token
        case lat
        case lon
        case page
        case per_page
        
        func queryItem(value:String) -> URLQueryItem {
            return URLQueryItem(name:self.rawValue, value: value)
        }
        func queryItem<T:RawRepresentable where T.RawValue == String>(value:T) -> URLQueryItem {
            return URLQueryItem(name:self.rawValue, value: value.rawValue)
        }
    }
    
    enum Path: String {
        case root = "/services/rest"
    }
    
    enum Methods: String {
        case interestingness = "flickr.interestingness.getList"
    }
    
    enum Formats: String {
        case json
    }
    
}
