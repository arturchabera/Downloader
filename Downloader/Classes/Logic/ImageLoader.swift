//
//  ImageLoader.swift
//  Downloader
//
//  Created by Majid Jabrayilov on 5/14/19.
//

import UIKit

public class ImageLoader {
    public static let shared = ImageLoader()

    private let loader: DataLoader
    
    private init() {
        loader = DataLoader(config: .standard)
    }

    @discardableResult
    public func load(_ url: URL, handler: @escaping Handler<UIImage>) -> CancellationToken? {
        return loader.fetch(url) { result in
            do {
                let data = try result.get()
                if let image = UIImage(data: data) {
                    handler(.success(image))
                }
            } catch {
                handler(.failure(error))
            }
        }
    }
}
