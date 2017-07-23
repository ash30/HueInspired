//
//  PaletteCreatorView.swift
//  HueInspired
//
//  Created by Ashley Arthur on 18/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

protocol PaletteCreator {
    // Can't name this delegate as it sometimes clashes 
    // with UIKit properties
    var controller: PaletteCreatorDelegate? { get set }
}

protocol PaletteCreatorDelegate {
    func didSelectUserImage(creator:UIViewController, image: UIImage, id:String)
}

enum PaletteErrors: Error {
    case paletteCreationFailure
}
