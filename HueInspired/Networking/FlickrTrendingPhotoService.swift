//
//  TrendingPaletteService.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit


class FlickrTrendingPhotoService {
    
    // Simple Service to request next trending Flickr Photos
    
    enum ServiceError: Error {
        case deallocError
    }
    
    private let photoService:FlickrService
    private let workQueue = DispatchQueue(label: "DailyTrendsRemotePhotoService_Queue")
    
    private var currentPhotoBatch: Promise<[FlickrPhotoResource]>!
    private var currentPage:Int = 1
    
    // MARK: INIT
    
    init(photoService:FlickrService) {
        self.photoService = photoService
    }
    
    // MARK: PUBLIC METHODS
    
    func resume() {
        // If previously used, fast forward so we don't return previously used photos
    }
    
    func prefetch(){
        currentPhotoBatch = photoService.getLatestInterests(date: Date.init(), page: currentPage)
    }
    
    func next() -> Promise<FlickrPhoto> {
        // pop next photo from current photos if available, else get it first
        // send of for request

        
        let p = Promise<FlickrPhoto>.pending()
        
        // We have to serialise access to ensure next calls are serviced in order

        workQueue.sync {
            if currentPhotoBatch == nil || currentPhotoBatch.isRejected{
                // Try Resending if not batch
                self.currentPhotoBatch = photoService.getLatestInterests(date: Date.init(), page: currentPage)
            }
            
            // if batch is exhausted we need to resend....
            if currentPhotoBatch.isFulfilled && (currentPhotoBatch.value?.count ?? -1) < 1 {
                getNextBatch()
            }
            
            _ = self.currentPhotoBatch.then { [weak self] (r:[FlickrPhotoResource]) -> Promise<FlickrPhotoResource?> in
                
                // Pop last and update batch
                let last = Promise<FlickrPhotoResource?>.pending()
                self?.workQueue.async {
                    
                    guard let _self = self else {
                        last.reject(ServiceError.deallocError)
                        return
                    }
                    // You'll only reach here if currentPhotoBatch has been fullfilled( i think ...)
                    // hence its ok to force cast the value optional
                    var resources = _self.currentPhotoBatch.value!
                    let res = resources.popLast()
                    _self.currentPhotoBatch = Promise(value: resources)
                    last.fulfill(res)
                }
                return last.promise
            }
            .then { [weak self] (r:FlickrPhotoResource?) -> () in
                
                // Self may not be around by this point, grab strong ref
                guard let _self = self else {
                    p.reject(ServiceError.deallocError)
                    return
                }
                
                // There is the potential for Resource to be nil
                // As calls to 'next' exceded pending batch size.
                // a retry will force a new batch
                guard let photoResource = r else {
                    _ = _self.next().then { p.fulfill($0) }
                    return
                }
                
                _ = _self.photoService.getPhoto(photoResource).then { 
                    p.fulfill($0)
                }
            }

        }
        return p.promise
    }
    
    // MARK: PRIVATE
    
    private func getNextBatch() {
        // Increments page and keeps batch in sync, should only be called from work queue
        
        currentPage += 1
        currentPhotoBatch = photoService.getLatestInterests(date: Date.init(), page: currentPage)
    }

}
