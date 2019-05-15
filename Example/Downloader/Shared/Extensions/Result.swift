//
//  Result.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

typealias Outcome = Result<Void, Error>
typealias Handler<T> = (Result<T, Error>) -> Void

extension Result where Success == Data {
    func decode<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        return try decoder.decode(T.self, from: get())
    }
}
