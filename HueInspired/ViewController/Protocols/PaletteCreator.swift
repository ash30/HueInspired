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
}

protocol PaletteCreatorDelegate {
    func didSelectUserImage(creator:UIViewController, image: UIImage, id:String)
}

enum PaletteErrors: Error {
    case paletteCreationFailure
}
