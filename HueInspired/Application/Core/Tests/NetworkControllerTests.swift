//
//  NetworkControllerTests.swift
//  HueInspired
//
//  Created by Ashley Arthur on 25/09/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Quick

class NetworkControllerSpec: QuickSpec {
    
    override func spec() {
        
        describe("NetworkController.getData"){
            
            context("Given A Url"){
                
                it("should send a network request for the resource"){
                    
                }
                
                it("should fulfill returned promised with network data"){
                    
                }

                it("should reject returned promise if requests errors"){
                    
                    context("URL Session Error"){
                        
                    }
                    
                    context("Non succesful request"){
                        
                    }
                    
                }
            }
        }
    }
}
