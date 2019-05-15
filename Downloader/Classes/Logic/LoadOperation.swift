//
//  LoadOperation.swift
//  Downloader
//
//  Created by Majid Jabrayilov on 5/14/19.
//

import Foundation

class LoadOperation: AsyncOperation {
    private let url: URL
    private let session: URLSession
    private var dataTask: URLSessionDataTask?

    var handler: DataHandler?

    init(url: URL, session: URLSession) {
        self.session = session
        self.url = url
    }

    override func main() {
        state = .executing
        dataTask = session.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                self?.handler?(.failure(error))
            } else {
                self?.handler?(.success(data ?? Data()))
            }
            self?.state = .finished
        }
        dataTask?.resume()
    }

    override func cancel() {
        super.cancel()
        dataTask?.cancel()
    }
}
