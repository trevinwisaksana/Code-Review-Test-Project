//
//  UIImage+Size.swift
//  Makestagram
//
//  Created by Trevin Wisaksana on 08/12/2017.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension UIImage {
    var aspectHeight: CGFloat {
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        return size.height / aspectRatio
    }
}
