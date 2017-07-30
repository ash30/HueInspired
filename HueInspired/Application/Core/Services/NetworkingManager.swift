//
//  NetworkingManager.swift
//  HueInspired
//
//  Created by Ashley Arthur on 18/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit

protocol NetworkManager {
    
    // Any object capable of sending a request to the network regardless of 
    // underlying protocol
    
    func getData(_ request:URL, level: DispatchQoS.QoSClass) -> Promise<Data>

}

class HTTPClient {
    
    enum NetworkError: Error  {
        case client(Error)
        case server(Int)
        case urlSessionError
    }
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
}

extension HTTPClient: NetworkManager {
    
    // The Responsibility here is to correctly model Errors
    // and pass response on for someone else to parse
    
    func getData(_ request:URL, level: DispatchQoS.QoSClass) -> Promise<Data> {
        
        let (task, request) =  session.dataTaskPromise(with: request)
        
        defer{
            DispatchQueue.global(qos: level).async {
                task.resume()
            }
        }
        
        return request.then { (response: URLResponse?, data: Data?) in
            
            // no error was given but for some reason theres no data or response
            guard
                let data = data,
                let response = response as? HTTPURLResponse
            else {
                throw  NetworkError.urlSessionError
            }
            
            guard
                response.statusCode >= 200,
                response.statusCode <= 299
            else {
                throw NetworkError.server(response.statusCode)
            }
            
            return Promise(value: data)
            
        }
    }
    
    
}

