//
//  FlickrPhoto.swift
//  HueInspired
//
//  Created by Ashley Arthur on 15/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

struct FlickrPhotoResource {
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
    var url: URL {
        return URL.init(string:"https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_z.jpg")!
    }
}

extension FlickrPhotoResource {
    
    init?(jsonResponse:[String:Any]) {
        
        guard
            let id = jsonResponse["id"] as? String,
            let owner = jsonResponse["owner"] as? String,
            let secret = jsonResponse["secret"] as? String,
            let server = jsonResponse["server"] as? String,
            let farm = jsonResponse["farm"] as? Int,
            let title = jsonResponse["title"] as? String
            else {
                return nil
        }
        self.init(id: id, owner: owner, secret: secret, server: server, farm: farm, title: title)
    }
    
}
