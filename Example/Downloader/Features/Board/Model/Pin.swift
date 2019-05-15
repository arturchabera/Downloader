//
//  Board.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct Pin: Decodable {
    let id: String
    let likedByUser: Bool
    let user: User
    let urls: Image
}

struct Image: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Decodable {
    let id: String
    let username: String
    let name: String
    let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}

typealias Board = [Pin]
