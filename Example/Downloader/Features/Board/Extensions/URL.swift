//
//  URL.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid URL string: \(string)")
        }

        self = url
    }
}
