//
//  test_paletteDataSource.swift
//  HueInspired
//
//  Created by Ashley Arthur on 23/01/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


class TestPaletteDataSource: PaletteDataSource {
    
    // MARK: Properties
    var observer: DataSourceObserver?
    var testData: [ColorPalette] = []
    var count: Int {
        return testData.count
    }
    
    // MARK: Inits
    
    init(){
        syncData()
    }
        
    // MARK: Palette Data Source
    
    func getElement(at index:Int) -> ColorPalette? {
        guard index < testData.count else{
            return nil
        }
        return testData[index]
    }
    
    func syncData() {
        testData = (0...6).map {
            return generateTestPalette(name: "Palette\($0)")
        }
    }
    
}

// MARK: Helpers

func generateTestPalette(name:String?) -> ColorPalette {
    
    let colors: [SimpleColor] = (0...5).map{_ in
        let values: [Int] = (0...2).map{_ in Int(arc4random() % 256)}
        return SimpleColor(r: values[0], g: values[1], b: values[2])
    }
    return ImmutablePalette(name: name, colorData: colors, image: nil, guid:nil)
}
