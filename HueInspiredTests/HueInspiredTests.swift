//
//  HueInspiredTests.swift
//  HueInspiredTests
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import XCTest
@testable import HueInspired

class HueInspiredTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: COLOR EQUALITY
    
    func test_SimpleColor_Equality_isTrue() {
        let color1 = SimpleColor(r: 1, g: 1, b: 1)
        let color2 = SimpleColor(r: 1, g: 1, b: 1)
        XCTAssertTrue(color1 == color2)
    }
    
    func test_SimpleColor_Equality_Symmerty_isTrue() {
        let color1 = SimpleColor(r: 1, g: 1, b: 1)
        let color2 = SimpleColor(r: 1, g: 1, b: 1)
        XCTAssertTrue(color2 == color1)
    }
    
    func test_SimpleColor_Equality_SameReference_isTrue() {
        let color1 = SimpleColor(r: 1, g: 1, b: 1)
        XCTAssertTrue(color1 == color1)
    }
    
    func test_SimpleColor_Equality_Indice1Changed_isFalse() {
        let color1 = SimpleColor(r: 2, g: 1, b: 1)
        let color2 = SimpleColor(r: 1, g: 1, b: 1)
        XCTAssertFalse(color1 == color2)
    }
    
    func test_SimpleColor_Equality_Indice2Changed_isFalse() {
        let color1 = SimpleColor(r: 1, g: 2, b: 1)
        let color2 = SimpleColor(r: 1, g: 1, b: 1)
        XCTAssertFalse(color1 == color2)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: BOX MIN MAX
    
    func test_MaxR(){
        let color1 = SimpleColor(r: 10, g: 2, b: 1)
        let color2 = SimpleColor(r: 1, g: 1, b: 1)
        let color3 = SimpleColor(r: 9, g: 1, b: 1)
        
        let box = ColorBox(colors: [color1,color2,color3])
        XCTAssertEqual(box.rMax ?? 0, 10)
    }
    
    func test_MinR(){
        let color1 = SimpleColor(r: 10, g: 2, b: 1)
        let color2 = SimpleColor(r: 1, g: 1, b: 1)
        let color3 = SimpleColor(r: 9, g: 1, b: 1)
        
        let box = ColorBox(colors: [color1,color2,color3])
        XCTAssertEqual(box.rMin ?? 0, 1)
    }
    
    // MARK: Splitting
    
    func test_SplitBox_withOneColor(){
        let color1 = SimpleColor(r: 9, g: 1, b: 1)
        let box = ColorBox(colors: [color1])
        let result = box.split()
        XCTAssertNil(result)
    }
    
    func test_SplitBox_withTwoColor(){
        let color1 = SimpleColor(r: 9, g: 1, b: 1)
        let color2 = SimpleColor(r: 1, g: 1, b: 1)
        let box = ColorBox(colors: [color1,color2])
        let result = box.split()
        XCTAssertEqual(result?.0.count ?? 0, 1)
        XCTAssertEqual(result?.1.count ?? 0, 1)
        XCTAssertTrue(
            Set(result!.0.colors).isDisjoint(with:Set(result!.1.colors))
        )
    }
    
    func test_SplitBox_withTenColor(){
        let colors = Array(0...9).map{
            SimpleColor(r: $0, g: 1, b: 1)
        }
        let box = ColorBox(colors: colors)
        let result = box.split()
        
        XCTAssertEqual(result?.0.count ?? 0, 5)
        XCTAssertEqual(result?.1.count ?? 0, 5)
        XCTAssertTrue(
            Set(result!.0.colors).isDisjoint(with:Set(result!.1.colors))
        )
        
    }
}

class ExtractionTests: XCTestCase {
    
    // We should extract 512*512 pixels from image
    func create(_ image:UIImage, i:Int) -> [ColorBox]{
        let transformedImage = createFixedSizedSRGBThumb(image: image.cgImage!)
        XCTAssertNotNil(transformedImage)
        let result = extractPixelData(image: transformedImage!)
        XCTAssertEqual(result?.count ?? 0, 262144)
        return divideSpace(colors: result!, numberOfBoxes: i)
    }
    
    func test_1col_512(){
        let result = create(UIImage(named: "testImage512")!, i:20)
    }


}
