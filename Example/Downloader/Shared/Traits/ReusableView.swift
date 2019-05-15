//
//  ReusableView.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

typealias NibReusableView = NibLoadableView & ReusableView

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: NibReusableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T
            else { fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)") }
        return cell
    }
}
