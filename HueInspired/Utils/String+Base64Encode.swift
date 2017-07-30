//
//  String+Base64Encode.swift
//  HueInspired
//
//  Created by Ashley Arthur on 17/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
}
