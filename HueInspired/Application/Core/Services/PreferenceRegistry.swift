//
//  UserPrefrences.swift
//  HueInspired
//
//  Created by Ashley Arthur on 10/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

protocol PreferenceRegistry {
    
    func set(_ value: Int, forKey defaultName: String)
    func get(forKey defaultName: String) -> Int
    
}

extension UserDefaults: PreferenceRegistry {
    
    func get(forKey defaultName: String) -> Int {
        return self.integer(forKey:defaultName)
    }

}
