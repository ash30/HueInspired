//
//  NetworkAssembly.swift
//  HueInspired
//
//  Created by Ashley Arthur on 16/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import Swinject
import CoreData


class NetworkAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: CORE NETWORK 
        
        container.register(NetworkManager.self){ _ in
            HTTPClient.init(session: URLSession.shared)
        }.inObjectScope(.container)
        
        
    }
    
}
