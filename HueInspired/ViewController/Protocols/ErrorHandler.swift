//
//  ErrorReporting.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


protocol ErrorHandler {
    
    // Protocol for view controller that is able
    // to report errors to user.
    
    func report(error:Error)
    
}

extension ErrorHandler where Self:UIViewController {
    
    func report(error:Error){
        showErrorAlert(title: "Error", message: String(describing: error))
    }
    
    func showErrorAlert(title:String, message:String){
        // Utility method to create alert VC to display error
        
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc.addAction(
            UIAlertAction(
                title: "Ok",
                style:.default,
                handler: {_ in self.dismiss(animated: true, completion: nil)}
        ))
        present(vc, animated: true){
        }
    }
}
