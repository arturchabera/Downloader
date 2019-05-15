//
//  BoardLayout.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class BoardLayout: UICollectionViewFlowLayout {
    private enum Layout {
        static let ratio: CGFloat = 1.7
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }

        let columns: CGFloat = collectionView.traitCollection.horizontalSizeClass == .compact ? 2 : 4
        let width = collectionView.bounds.width / columns

        itemSize = .init(width: width, height: width * Layout.ratio)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
}
