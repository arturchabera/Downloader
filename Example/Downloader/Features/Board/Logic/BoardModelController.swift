//
//  BoardModelController.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/14/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class BoardModelController {
    private(set) var board: [Pin] = []
    private var loading = false
    private var page = 0

    private let service: BoardService

    init(service: BoardService) {
        self.service = service
    }

    func fetch(handler: @escaping (Outcome) -> Void) {
        page = 0
        service.fetch { [weak self] result in
            switch result {
            case let .success(pins):
                self?.board.removeAll()
                self?.board.append(contentsOf: pins)
                handler(.success(()))
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }

    func fetchNextPage(handler: @escaping (Outcome) -> Void) {
        guard !loading else {
            return
        }

        loading = true
        page += 1
        service.fetch { [weak self] result in
            self?.loading = false

            switch result {
            case let .success(pins):
                self?.board.append(contentsOf: pins)
                handler(.success(()))
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }
}
