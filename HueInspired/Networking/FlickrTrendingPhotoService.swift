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
    
    // Simple Service to request next trending Flickr Photo
    
    enum ServiceError: Error {
        case deallocError
    }
    
    // MARK: PROPERTIES
    
    private let photoService:FlickrService
    private let workQueue = DispatchQueue(label: "FlickrTrendingPhotoService_Queue")
    private let preferences: PreferenceRegistry?
    
    private var currentPhotoBatch: Promise<[FlickrPhotoResource]>!
    private var currentPage:Int = 1
    
    // MARK: INIT
    
    init(photoService:FlickrService, preferences:PreferenceRegistry? = nil) {
        self.photoService = photoService
        self.preferences = preferences
    }
    
    // MARK: PUBLIC METHODS
    
    func resume() {
        // Fast forward currentPage so we don't return previous photos
        
        guard let preferences = preferences else {
            return // No preferences to restore from
        }
        let lastBatch = preferences.get(forKey: FlickrTrendingPhotoService.previousBatchPreferenceKey)
        
        // may not have saved a pref, always skip forward by 1
        currentPage = max(lastBatch, 1) + 1
        preferences.set(currentPage, forKey: FlickrTrendingPhotoService.previousBatchPreferenceKey)

    }
    
    func next() -> Promise<FlickrPhoto> {
        // Pop last item off current batch, get next batch of photos if empty

        let p = Promise<FlickrPhoto>.pending()
        
        workQueue.sync {
            if currentPhotoBatch == nil || currentPhotoBatch.isRejected{
                fetch()
            }
            if currentPhotoBatch.isFulfilled && (currentPhotoBatch.value?.count ?? -1) < 1 {
                getNextBatch() // if batch is exhausted we need to resend....

            }
            
            // pop current last item and mutate remaining batch
            _ = self.currentPhotoBatch.then { [weak self] _ -> Promise<FlickrPhotoResource?> in
                
                let p = Promise<FlickrPhotoResource?>.pending()
                
                guard let _self = self else {
                    p.reject(ServiceError.deallocError)
                    return p.promise
                }

                _self.workQueue.async {
                    var resources = _self.currentPhotoBatch.value! // should ALWAYS be true
                    let item = resources.popLast()
                    _self.currentPhotoBatch = Promise(value: resources)
                    p.fulfill(item)
                }
                return p.promise
                
            }
            .then { [weak self] (r:FlickrPhotoResource?) -> () in
                
                // Self may not be around by this point, grab strong ref
                guard let _self = self else {
                    p.reject(ServiceError.deallocError)
                    return
                }
                
                // There is the potential for Resource to be nil, calls to 'next' exceeded pending batch size
                //  aka popped empty resource list, a retry will force a new batch
                guard let photoResource = r else {
                    _ = _self.next().then { p.fulfill($0) }
                    return
                }
                
                _ = _self.photoService.getPhoto(photoResource).then { 
                    p.fulfill($0)
                }
                
            }
            .catch { (err:Error) -> () in
            // If initial call to create batch fails, we need to propagate error
                p.reject(err)
            }

        }
        return p.promise
    }
    
    // MARK: PRIVATE
    
    private func fetch(){
        let yesterday = Calendar.current.date(byAdding: Calendar.Component.day, value: -1, to: Date())
        currentPhotoBatch = photoService.getLatestInterests(date: yesterday, page: currentPage)
    }
    
    private func getNextBatch() {
        // Increments page and keeps batch in sync, should only be called from work queue
        currentPage += 1
        preferences?.set(currentPage, forKey: FlickrTrendingPhotoService.previousBatchPreferenceKey)
        fetch()
    }

}
