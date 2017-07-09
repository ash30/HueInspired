//
//  TrendingPaletteServiceTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import XCTest
import PromiseKit
@testable import HueInspired

class TrendingPaletteServiceTests: XCTestCase {
    
    class MockFlickrService: FlickrService {
        func getLatestInterests(date:Date?, page:Int) -> Promise<[FlickrPhotoResource]> {
            
            let payload = (0...3).map {
                FlickrPhotoResource.init(id: String($0), owner: "me", secret: "foo", server: "bar", farm: 0, title: "spam")
            }
            return Promise<[FlickrPhotoResource]>(value: payload)
            
        }
        func getPhoto(_ resource: FlickrPhotoResource) -> Promise<FlickrPhoto> {
            let payload = FlickrPhoto.init(description: resource, image: UIImage.init(named: "testImage512")!)
            return Promise<FlickrPhoto>(value: payload)
        }

    }
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_nextItem() {
        // calls to next return current last item in batch
        
        let service = FlickrTrendingPhotoService(photoService: MockFlickrService())
        let e = expectation(description: "Should return a mock photo")
        
        _ = service.next().then { (photo:FlickrPhoto) -> () in
            XCTAssertEqual(photo.description.server, "bar")
            XCTAssertEqual(photo.description.id, "3")
            e.fulfill()
        }.catch { _ in 
            print("")
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func test_nextItemMultiple() {
        // Subsequent calls to next should return items in call order
        
        let service = FlickrTrendingPhotoService(photoService: MockFlickrService())
        
        // TEST
        let firstElement = expectation(description: "Should return a mock photo with id 3")
        let SecondElement = expectation(description: "Should return a mock photo with id 2")
        _ = service.next().then { (photo:FlickrPhoto) -> () in
            XCTAssertEqual(photo.description.server, "bar")
            XCTAssertEqual(photo.description.id, "3")
            firstElement.fulfill()
        }
    
        _ = service.next().then { (photo:FlickrPhoto) -> () in
            XCTAssertEqual(photo.description.server, "bar")
            XCTAssertEqual(photo.description.id, "2")
            SecondElement.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func test_nextItemMultiple_nextBatch() {
        // having made enough calls to next to exhaust the current batch,
        // it should make another request to photo service for next batch
        
        let service = FlickrTrendingPhotoService(photoService: MockFlickrService())
        
        // TEST
        let e = expectation(description: "Should return a mock photo with id 3")
        
        _ = service.next()
        _ = service.next()
        _ = service.next()
        _ = service.next() // new batch starts here
        _ = service.next()

        
        _ = service.next().then { (photo:FlickrPhoto) -> () in
            XCTAssertEqual(photo.description.server, "bar")
            XCTAssertEqual(photo.description.id, "2")
            e.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func test_batchCreationErrors(){
        // If photoservice errors, we need to error as well! 
    }
    
}
