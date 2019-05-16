//
//  DataService.swift
//  Downloader
//
//  Created by Majid Jabrayilov on 5/13/19.
//

import Foundation

public class DataLoader {
    private var cancellationTokens: [CancellationToken] = []
    private var ongoing: [URL: Operation] = [:]
    private let safeQueue = DispatchQueue(label: "DataLoader.RaceCondition.Queue")
    private let queue: OperationQueue
    private let cache: LRUCache<URL, Data>
    private let session: URLSession

    public init(config: Configuration = .standard) {
        cache = .init(config.cacheSize)
        session = .shared
        queue = .init()
        queue.maxConcurrentOperationCount = config.maxConcurrentOperationCount
    }

    public init(session: URLSession, cache: LRUCache<URL, Data>, queue: OperationQueue) {
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

                guard ongoing[url] == nil else {
                    return
                }

                let operation = LoadOperation(url: url, session: session)
                operation.handler = { [weak self] result in
                    self?.handle(result, for: url)
                }

                ongoing[url] = operation
                queue.addOperation(operation)
            }

            return token
        }
    }

    func cancel(_ token: CancellationToken) {
        safeQueue.sync {
            cancellationTokens.removeAll { $0 == token }
            if cancellationTokens.filter({ $0.url == token.url }).isEmpty {
                let operation = ongoing.removeValue(forKey: token.url)
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
            ongoing.removeValue(forKey: url)
        }
    }
}

extension DataLoader {
    public struct Configuration {
        let cacheSize: Int
        let maxConcurrentOperationCount: Int

        public init(cacheSize: Int, maxConcurrentOperationCount: Int) {
            self.maxConcurrentOperationCount = maxConcurrentOperationCount
            self.cacheSize = cacheSize
        }

        public static let standard = Configuration(cacheSize: 15, maxConcurrentOperationCount: 10)
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
