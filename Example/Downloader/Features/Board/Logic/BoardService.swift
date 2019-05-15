//
//  BoardService.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Downloader

class BoardService {
    private enum Constants {
        static let api = URL(staticString: "http://pastebin.com/raw/wgkJgazE")
    }
    
    private let loader: DataLoader
    private let decoder: JSONDecoder

    init(loader: DataLoader, decoder: JSONDecoder) {
        self.loader = loader
        self.decoder = decoder
    }

    func fetch(handler: @escaping Handler<Board>) {
        loader.fetch(Constants.api) { [weak self] result in
            guard let self = self else {
                return
            }

            handler(Result { try result.decode(using: self.decoder) })
        }
    }
}
