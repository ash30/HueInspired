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
    
    static private let API_KEY_PLIST_KEY = "FLICKR_API_KEY"

    
    let scheme : String = "https"
    let host: String = "api.flickr.com"
    let Key: String = {
        guard
            let path = Bundle.main.path(forResource: "flickr", ofType: "plist"),
            let dict = NSDictionary.init(contentsOfFile: path),
            let val =  dict[API_KEY_PLIST_KEY] as? String
            else {
                fatalError("NO FLICKR API KEY")
        }
        return val
    }()
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
