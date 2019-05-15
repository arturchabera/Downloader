//
//  RootFactory.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/14/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Downloader

protocol DependencyFactory {
    func makeBoardService() -> BoardService
    func makeDataLoader() -> DataLoader
}

class RootFactory {
    let session: URLSession
    let decoder: JSONDecoder

    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
    }
}

extension RootFactory: DependencyFactory {
    func makeBoardService() -> BoardService {
        return .init(loader: makeDataLoader(), decoder: decoder)
    }

    func makeDataLoader() -> DataLoader {
        return DataLoader(
            session: session,
            cache: LRUCache<URL, Data>(10),
            queue: .init()
        )
    }
}
