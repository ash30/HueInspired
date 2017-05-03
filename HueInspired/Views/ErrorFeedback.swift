//
//  ErrorReporting.swift
//  HueInspired
//
//  Created by Ashley Arthur on 09/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorFeedback {
}

extension ErrorFeedback where Self:UIViewController
{
    func showErrorAlert(title:String, message:String){
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
