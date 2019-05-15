//
//  PinPresentation.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct PinPresentation {
    var avatarUrl: URL? {
        return URL(string: pin.user.profileImage.large)
    }

    var imageUrl: URL? {
        return URL(string: pin.urls.regular)
    }

    var username: String {
        return pin.user.name
    }

    private let pin: Pin

    init(pin: Pin) {
        self.pin = pin
    }
}
