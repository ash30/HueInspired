//
//  UrlSession+Promise.swift
//  HueInspired
//
//  Created by Ashley Arthur on 04/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import PromiseKit

// I want to create a data task and send it and return a promise
// So We extend URLSession to provide a promise

extension URLSession {
    
    func dataTaskPromise(with request: URL) -> (URLSessionDataTask, Promise<(URLResponse?,Data?)>) {
        
        let (promise, furfil, reject) = Promise<(URLResponse?,Data?)>.pending()
        
        let task = dataTask(with: request){ (data,response,error) in
            guard error == nil else {
                reject(error!)
                return
            }
            furfil((response, data))
        }
        return (task, promise)
    }
}
