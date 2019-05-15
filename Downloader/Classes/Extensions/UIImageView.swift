//
//  UIImageView.swift
//  Downloader
//
//  Created by Majid Jabrayilov on 5/14/19.
//

import UIKit

extension UIImageView {
    @discardableResult
    public func setImage(from url: URL) -> CancellationToken? {
        return ImageLoader.shared.load(url) { [weak self] result in
            let image = try? result.get()
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
