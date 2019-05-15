//
//  DataService.swift
//  Downloader
//
//  Created by Majid Jabrayilov on 5/13/19.
//

import Foundation

public class DataLoader {
    private var cancellationTokens: [CancellationToken] = []
    private var operations: [URL: Operation] = [:]
    private let safeQueue = DispatchQueue(label: "DataLoader.RaceCondition.Queue")
    private let queue: OperationQueue
    private let cache: LRUCache<URL, Data>
    private let session: URLSession

    public init(session: URLSession, cache: LRUCache<URL, Data>, queue: OperationQueue) {
        queue.maxConcurrentOperationCount = 10
        
        self.session = session
        self.cache = cache
        self.queue = queue
    }

    @discardableResult
    public func fetch(_ url: URL, handler: @escaping Handler<Data>) -> CancellationToken? {
        if let data = cache.get(url) {
            safeQueue.async {
                handler(.success(data))
            }
            return nil
        } else {
            let token = CancellationToken(url: url, handler: handler, loader: self)

            safeQueue.sync {
                cancellationTokens.append(token)

                guard cancellationTokens.filter ({ $0.url == url }).count == 1 else {
                    return
                }

                let operation = LoadOperation(url: url, session: session)
                operation.handler = { [weak self] result in
                    self?.handle(result, for: url)
                }

                operations[url] = operation
                queue.addOperation(operation)
            }

            return token
        }
    }

    func cancel(_ token: CancellationToken) {
        safeQueue.sync {
            cancellationTokens.removeAll { $0 == token }
            if cancellationTokens.filter({ $0.url == token.url }).count == 0 {
                let operation = operations.removeValue(forKey: token.url)
                operation?.cancel()
            }
        }
    }

    private func handle(_ result: Result<Data, Error>, for url: URL) {
        safeQueue.sync {
            let tokens = cancellationTokens.filter { $0.url == url }

            switch result {
            case let .success(data):
                tokens.forEach { $0.handler(.success(data)) }
                cache.set(url, value: data)
            case let .failure(error):
                tokens.forEach { $0.handler(.failure(error)) }
            }

            cancellationTokens.removeAll { $0.url == url }
            operations.removeValue(forKey: url)
        }
    }
}

public class CancellationToken {
    let url: URL
    let handler: DataHandler
    weak var loader: DataLoader?

    init(url: URL, handler: @escaping DataHandler, loader: DataLoader) {
        self.url = url
        self.handler = handler
        self.loader = loader
    }

    public func cancel() {
        loader?.cancel(self)
    }
}

extension CancellationToken: Hashable {
    public static func == (lhs: CancellationToken, rhs: CancellationToken) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}