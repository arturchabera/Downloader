//
//  RoundedImageView.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/14/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
}
