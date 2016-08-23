//
//  SAPinConstants.swift
//  PINManagement
//
//  Created by Siavash on 21/08/2016.
//  Copyright © 2016 Siavash Abbasalipour. All rights reserved.
//

import Foundation
import UIKit

struct SAPinConstant {
    
    static let ButtonPadding = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? UIScreen.mainScreen().bounds.width * 0.069 : 320 * 0.069
    static let ButtonWidth: CGFloat = 65.0
    static let CircleWidth: CGFloat = 12
    static let CancelString = "Cancel"
    static let DeleteString = "Delete"
    static let DefaultFontName = "PingFang-TC-Regular"
    static let MaxNumberFontSize:CGFloat = 30
    static let MaxAlphabetFontSize: CGFloat = 10
    static let LogoImageWidth: CGFloat = 60
}