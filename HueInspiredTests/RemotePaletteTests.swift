//
//  ApplicationServiceTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 03/02/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//
import XCTest
import PromiseKit
import CoreData
import Swinject

@testable import HueInspired


class RemotePaletteServiceTests: XCTestCase {
    
    /*
        The Remote palette service should test that mock network data
        successfully gets transformed into palettes
     
        it should also test for errors in network service
    */

    class MockPhotoService: FlickrService {
        
        func getLatestInterests() -> Promise<[FlickrPhotoResource]> {
            let example = FlickrPhotoResource(id: "", owner: "", secret: "", server: "", farm: 0, title: "")
            return Promise.init(value: Array.init(repeating: example , count: 3))
        }
        func getPhoto(_ resource: FlickrPhotoResource) -> Promise<FlickrPhoto> {
            let image = UIImage(named: "testImage512")!
            return Promise(value: FlickrPhoto(description: resource, image: image))
        }
        
    }

    func test_mutipleImage() {
        // Make sure we return promise of array same length as photo service result
        
    }
    
}





